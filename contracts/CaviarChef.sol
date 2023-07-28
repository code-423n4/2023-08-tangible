// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
import "@boringcrypto/boring-solidity/contracts/BoringBatchable.sol";
import "@boringcrypto/boring-solidity/contracts/BoringOwnable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "./interfaces/ISmartWalletWhitelist.sol";
import "./interfaces/ISecondRewarder.sol";
import "./interfaces/IRewardSeeder.sol";
import "./libraries/SignedSafeMath.sol";

contract CaviarChef is OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using SafeMath for uint256;
    using BoringMath128 for uint128;
    using BoringERC20 for IERC20;
    using SignedSafeMath for int256;

    struct UserInfo {
        uint256 amount;
        int256 rewardDebt;
    }

    uint256 public accRewardPerShare;
    uint256 public lastRewardTime;

    address public rewardSeeder;

    /// @notice Address of rewardToken contract.
    IERC20 public rewardToken;

    /// @notice Address of the LP token for each MCV2 pool.
    IERC20 public underlying;

    /// @notice Info of each user that stakes LP tokens.
    mapping(address => UserInfo) public userInfo;

    uint256 public rewardPerSecond;
    uint256 private ACC_REWARD_PRECISION;

    uint256 public distributionPeriod;
    uint256 public lastDistributedTime;

    uint256 public overDistributed;

    address public smartWalletChecker;

    ISecondRewarder public rewarder;
    uint256 public rewarderPid;

    event Deposit(address indexed user, uint256 amount, address indexed to);
    event Withdraw(address indexed user, uint256 amount, address indexed to);
    event EmergencyWithdraw(address indexed user, uint256 amount, address indexed to);
    event Harvest(address indexed user, uint256 amount);
    event LogUpdatePool(uint256 lastRewardTime, uint256 underlyingSupply, uint256 accRewardPerShare);
    event LogRewardPerSecond(uint256 rewardPerSecond);

    string public __NAME__;

    constructor() public {}

    function initialize(
        string memory _name,
        IERC20 _rewardToken,
        IERC20 _underlying,
        address _rewardSeeder,
        uint256 _distributionPeriod,
        address _smartWalletChecker
    ) public initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
        __NAME__ = _name;
        rewardToken = _rewardToken;
        distributionPeriod = _distributionPeriod;
        ACC_REWARD_PRECISION = 1e12;
        underlying = _underlying;
        lastRewardTime = block.timestamp;
        rewardSeeder = _rewardSeeder;
        smartWalletChecker = _smartWalletChecker;
    }

    modifier onlyWhitelisted() {
        if (tx.origin != msg.sender) {
            require(address(smartWalletChecker) != address(0), "Not whitelisted");
            require(ISmartWalletWhitelist(smartWalletChecker).check(msg.sender), "Not whitelisted");
        }
        _;
    }

    function setDistributionPeriod(uint256 _distributionPeriod) public onlyOwner {
        distributionPeriod = _distributionPeriod;
    }

    function setSmartWalletChecker(address _checker) public onlyOwner {
        smartWalletChecker = _checker;
    }

    function setSecondRewarder(ISecondRewarder _rewarder, uint256 _pid) public onlyOwner {
        rewarder = _rewarder;
        rewarderPid = _pid;
    }

    /// @notice Sets the reward per second to be distributed. Can only be called by the owner.
    /// @param _rewardPerSecond The amount of Reward to be distributed per second.
    function setRewardPerSecond(uint256 _rewardPerSecond) public onlyOwner {
        rewardPerSecond = _rewardPerSecond;
        emit LogRewardPerSecond(_rewardPerSecond);
    }

    function _setDistributionRate(uint256 amount) internal {
        updatePool();
        uint256 _notDistributed;
        if (lastDistributedTime > 0 && block.timestamp < lastDistributedTime) {
            uint256 timeLeft = lastDistributedTime.sub(block.timestamp);
            _notDistributed = rewardPerSecond.mul(timeLeft);
        }

        amount = amount.add(_notDistributed);

        uint256 _moreDistributed = overDistributed;
        overDistributed = 0;

        if (lastDistributedTime > 0 && block.timestamp > lastDistributedTime) {
            uint256 timeOver = block.timestamp.sub(lastDistributedTime);
            _moreDistributed = _moreDistributed.add(rewardPerSecond.mul(timeOver));
        }

        if (amount < _moreDistributed) {
            overDistributed = _moreDistributed.sub(amount);
            rewardPerSecond = 0;
            lastDistributedTime = block.timestamp.add(distributionPeriod);
            updatePool();
            emit LogRewardPerSecond(rewardPerSecond);
        } else {
            amount = amount.sub(_moreDistributed);
            rewardPerSecond = amount.div(distributionPeriod);
            lastDistributedTime = block.timestamp.add(distributionPeriod);
            updatePool();
            emit LogRewardPerSecond(rewardPerSecond);
        }
    }

    function setOverDistributed(uint256 _overDistributed) public onlyOwner {
        overDistributed = _overDistributed;
    }

    function seedRewards(uint256 _amount) external {
        IERC20(rewardToken).safeTransferFrom(msg.sender, rewardSeeder, _amount);
        if (_amount > 0) {
            _setDistributionRate(_amount);
        }
    }

    function pendingReward(address _user) external view returns (uint256 pending) {
        UserInfo storage user = userInfo[_user];
        uint256 underlyingSupply = underlying.balanceOf(address(this));
        uint256 _accRewardPerShare = accRewardPerShare;
        if (block.timestamp > lastRewardTime && underlyingSupply != 0) {
            uint256 time = block.timestamp.sub(lastRewardTime);
            uint256 rewardAmount = time.mul(rewardPerSecond);
            _accRewardPerShare = _accRewardPerShare.add(rewardAmount.mul(ACC_REWARD_PRECISION) / underlyingSupply);
        }
        pending = int256(user.amount.mul(_accRewardPerShare) / ACC_REWARD_PRECISION).sub(user.rewardDebt).toUInt256();
    }

    function updatePool() public returns (uint256) {
        if (block.timestamp > lastRewardTime) {
            uint256 underlyingSupply = underlying.balanceOf(address(this));
            if (underlyingSupply > 0) {
                uint256 time = block.timestamp.sub(lastRewardTime);
                uint256 rewardAmount = time.mul(rewardPerSecond);
                accRewardPerShare = accRewardPerShare.add(rewardAmount.mul(ACC_REWARD_PRECISION).div(underlyingSupply));
            }
            lastRewardTime = block.timestamp;
            emit LogUpdatePool(lastRewardTime, underlyingSupply, accRewardPerShare);
            return accRewardPerShare;
        }
    }

    function deposit(uint256 amount, address to) public onlyWhitelisted nonReentrant {
        updatePool();
        UserInfo storage user = userInfo[to];

        // Effects
        user.amount = user.amount.add(amount);
        user.rewardDebt = user.rewardDebt.add(int256(amount.mul(accRewardPerShare) / ACC_REWARD_PRECISION));

        if (address(rewarder) != address(0)) {
            rewarder.onReward(rewarderPid, to, to, 0, user.amount);
        }

        underlying.safeTransferFrom(msg.sender, address(this), amount);

        emit Deposit(msg.sender, amount, to);
    }

    function withdraw(uint256 amount, address to) public onlyWhitelisted nonReentrant {
        updatePool();
        UserInfo storage user = userInfo[msg.sender];

        // Effects
        user.rewardDebt = user.rewardDebt.sub(int256(amount.mul(accRewardPerShare) / ACC_REWARD_PRECISION));
        user.amount = user.amount.sub(amount);

        if (address(rewarder) != address(0)) {
            rewarder.onReward(rewarderPid, msg.sender, to, 0, user.amount);
        }

        underlying.safeTransfer(to, amount);

        emit Withdraw(msg.sender, amount, to);
    }

    function harvest(address to) public {
        updatePool();
        UserInfo storage user = userInfo[msg.sender];
        int256 accumulatedReward = int256(user.amount.mul(accRewardPerShare) / ACC_REWARD_PRECISION);
        uint256 _pendingReward = accumulatedReward.sub(user.rewardDebt).toUInt256();

        // Effects
        user.rewardDebt = accumulatedReward;

        IRewardSeeder(rewardSeeder).claim(_pendingReward, to);

        if (address(rewarder) != address(0)) {
            rewarder.onReward(rewarderPid, msg.sender, to, _pendingReward, user.amount);
        }

        emit Harvest(msg.sender, _pendingReward);
    }

    function withdrawAndHarvest(uint256 amount, address to) public onlyWhitelisted nonReentrant {
        updatePool();
        UserInfo storage user = userInfo[msg.sender];
        require(amount <= user.amount, "Withdraw amount exceeds the deposited amount.");
        int256 accumulatedReward = int256(user.amount.mul(accRewardPerShare) / ACC_REWARD_PRECISION);
        uint256 _pendingReward = accumulatedReward.sub(user.rewardDebt).toUInt256();

        // Effects
        user.rewardDebt = accumulatedReward.sub(int256(amount.mul(accRewardPerShare) / ACC_REWARD_PRECISION));
        user.amount = user.amount.sub(amount);

        IRewardSeeder(rewardSeeder).claim(_pendingReward, to);

        if (address(rewarder) != address(0)) {
            rewarder.onReward(rewarderPid, msg.sender, to, _pendingReward, user.amount);
        }

        underlying.safeTransfer(to, amount);

        emit Withdraw(msg.sender, amount, to);
        emit Harvest(msg.sender, _pendingReward);
    }

    function emergencyWithdraw(address to) public onlyWhitelisted nonReentrant {
        UserInfo storage user = userInfo[msg.sender];
        uint256 amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;

        if (address(rewarder) != address(0)) {
            rewarder.onReward(rewarderPid, msg.sender, to, 0, 0);
        }

        // Note: transfer can fail or succeed if `amount` is zero.
        underlying.safeTransfer(to, amount);
        emit EmergencyWithdraw(msg.sender, amount, to);
    }

    function setName(string memory _name) external onlyOwner {
        __NAME__ = _name;
    }
}
