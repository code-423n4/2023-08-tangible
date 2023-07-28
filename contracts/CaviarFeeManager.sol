// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "./interfaces/IRouter01.sol";
import "./interfaces/IPearlPair.sol";
import "./interfaces/ICaviarChef.sol";

contract CaviarFeeManager is OwnableUpgradeable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    string public __NAME__;
    uint256 constant FEE_MAX = 1000;
    uint256 public FEE_CHEF;
    uint256 public lastRewardTime;

    address public masterchef;
    address public treasury;
    address[] public tokens;

    address public pairFactory;
    address public router;
    address public caviarManager;

    mapping(address => bool) public isToken;
    mapping(address => uint256) internal tokenPos;
    mapping(address => IRouter01.route) public tokenToRoutes;
    mapping(address => bool) public isKeeper;

    address public caviar;
    address public usdr;
    address public usdc;

    mapping(address => IRouter01.route[]) public routes;
    IRouter01.route[] public usdrToUsdcRoute;

    uint256 public feeStaking;
    uint256 public feeTngbl;
    uint256 public feeRebaseVault;
    uint256 public feeMultiplier;

    address public pairSecondReward;
    address public caviarChef;

    address public pearlPair;

    address public pairSecondRewarder;

    address public incentiveVault;

    modifier keeper {
        require(isKeeper[msg.sender] == true || msg.sender == owner(), 'not keeper');
        _;
    }
    
    modifier restricted {
        require(msg.sender == caviarManager || msg.sender == owner(), 'not auth');
        _;
    }
    
    constructor() public {}
    
    function initialize(
        string memory _name
    ) public initializer {
        __Ownable_init();
        __NAME__ = _name;
    }

    function notifyRewards() external keeper {
        uint256 _before = IERC20(usdr).balanceOf(address(this));
        uint256 i;
        
        for (i = 0; i < tokens.length; i ++) {
            address _token = tokens[i];
            if (isToken[_token]) {
                _swapToUSDR(_token);
            }
        }
        uint256 _after = IERC20(usdr).balanceOf(address(this));
        uint256 _notified = _after - _before;

        if (_notified > 0) {
            _distributeFees(_notified);
        }
    }
    
    function swapToUSDR(address _token) public restricted {
        _swapToUSDR(_token);
    }

    function _swapToUSDR(address _token) internal {
        uint256 i;
        for (i = 0; i < routes[_token].length; i++) {
            IRouter01.route[] memory _routes = new IRouter01.route[](1);
            _routes[0] = routes[_token][i];
            address _from = _routes[0].from;
            uint256 _balance = IERC20(_from).balanceOf(address(this));
            IERC20(_from).safeApprove(router, 0);
            IERC20(_from).safeApprove(router, _balance);
            if (_balance > 0) {
                IRouter01(router).swapExactTokensForTokens(
                    _balance, 
                    0, 
                    _routes, 
                    address(this), 
                    block.timestamp
                );
            }
        }
    }

    function _swapUsdrToUsdc(uint256 _amount) internal {
        uint256 i;
        for (i = 0; i < usdrToUsdcRoute.length; i++) {
            IRouter01.route[] memory _routes = new IRouter01.route[](1);
            _routes[0] = usdrToUsdcRoute[i];
            address _from = _routes[0].from;

            uint256 _balance = IERC20(_from).balanceOf(address(this));
            
            if (_from == usdr) {
                _balance = _amount;
            }

            IERC20(_from).safeApprove(router, 0);
            IERC20(_from).safeApprove(router, _balance);
            if (_balance > 0) {
                IRouter01(router).swapExactTokensForTokens(
                    _balance, 
                    0, 
                    _routes, 
                    address(this), 
                    block.timestamp
                );
            }
        }
    }

    function addRewardToken(IRouter01.route[] memory _route) public onlyOwner {
        // require(!isToken[_route[0].from], "Already added");
        if (isToken[_route[0].from]) {
            delete routes[_route[0].from];
            for (uint i; i < _route.length; i++) {
                routes[_route[0].from].push(_route[i]);
            }
        }
        else {
            for (uint i; i < _route.length; i++) {
                routes[_route[0].from].push(_route[i]);
            }
            isToken[_route[0].from] = true;
            tokens.push(_route[0].from);
        }
    }

    function deleteRewardToken(address _token) external onlyOwner {
        require(isToken[_token], "Token is not enabled!!");
        delete routes[_token];
    }

    function enableRewardToken(address _token) external onlyOwner {
        isToken[_token] = true;
    }

    function disableRewardToken(address _token) external onlyOwner {
        isToken[_token] = false;
    }

    function setKeeper(address _keeper) external onlyOwner {
        require(_keeper != address(0));
        require(isKeeper[_keeper] == false);
        isKeeper[_keeper] = true;
    }

    function removeKeeper(address _keeper) external onlyOwner {
        require(_keeper != address(0));
        require(isKeeper[_keeper] == true);
        isKeeper[_keeper] = false;
    }
    
    function setRouter(address _router) external onlyOwner {
        require(_router != address(0), 'addr 0');
        router = _router;
    }

    function setCaviarChef(address _caviarChef) external onlyOwner {
        require(_caviarChef != address(0), 'addr 0');
        caviarChef = _caviarChef;
    }

    function setPairSecondRewarder(address _pairSecondRewarder) external onlyOwner {
        require(_pairSecondRewarder != address(0), 'addr 0');
        pairSecondRewarder = _pairSecondRewarder;
    }

    function setTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), 'addr 0');
        treasury = _treasury;
    }

    function setIncentiveVault(address _vault) external onlyOwner {
        require(_vault != address(0), 'addr 0');
        incentiveVault = _vault;
    }

    function setCaviarManager(address _caviarManager) external onlyOwner {
        require(_caviarManager != address(0), 'addr 0');
        caviarManager = _caviarManager;
    }

    function setCaviar(address _caviar) external onlyOwner {
        require(_caviar != address(0), 'addr 0');
        caviar = _caviar;
    }

    function setPearlPair(address _pair) external onlyOwner {
        require(_pair != address(0), 'addr 0');
        pearlPair = _pair;
    }

    function setFees(
        uint256 _feeStaking, 
        uint256 _feeTngbl, 
        uint256 _feeRebaseVault,
        uint256 _feeMultiplier
    ) external onlyOwner {
        require(
            _feeStaking + _feeTngbl == _feeMultiplier,
            "Invalid fee values"
        );
        require(
            _feeRebaseVault <= _feeMultiplier,
            "Invalid fee values"
        );
        feeStaking = _feeStaking;
        feeTngbl = _feeTngbl;
        feeRebaseVault = _feeRebaseVault;
        feeMultiplier = _feeMultiplier;
    }

    function _distributeFees(uint256 _amount) internal {
        uint256 _amountStaking = _amount.mul(feeStaking).div(feeMultiplier);
        uint256 _amountTngbl = _amount.sub(_amountStaking);

        IERC20(usdr).safeApprove(caviarChef, 0);
        IERC20(usdr).safeApprove(caviarChef, _amountStaking);
        ICaviarChef(caviarChef).seedRewards(_amountStaking);

        if(treasury != address(0)) {
            _swapUsdrToUsdc(_amountTngbl);
            uint256 _usdcBalance = IERC20(usdc).balanceOf(address(this));
            IERC20(caviar).safeTransfer(treasury, _usdcBalance);
        }
    }

    function distributeFees(uint256 _amount) external restricted {
        _distributeFees(_amount);
    }

    function distributeRebaseFees(uint256 _amount) external restricted {
        uint256 _caviarBalance;
        if (caviar == IPearlPair(pearlPair).token0()) {
            _caviarBalance = IPearlPair(pearlPair).reserve0();
        } else {
            _caviarBalance = IPearlPair(pearlPair).reserve1();
        }
        uint256 _caviarStaked = IERC20(caviar).balanceOf(caviarChef);
        uint256 _caviarTotal = _caviarBalance.add(_caviarStaked);
        uint256 _amountVault = _amount.mul(feeRebaseVault).div(feeMultiplier);
        uint256 _amountLeft = _amount;

        if(incentiveVault != address(0)) {
            IERC20(caviar).safeTransfer(incentiveVault, _amountVault);
            _amountLeft = _amount.sub(_amountVault);
        }

        uint256 _amountSecondReward = _amountLeft.mul(_caviarBalance).div(_caviarTotal);
        uint256 _amountStaking = _amountLeft.mul(_caviarStaked).div(_caviarTotal);

        IERC20(caviar).safeApprove(caviarChef, 0);
        IERC20(caviar).safeApprove(caviarChef, _amountStaking);
        ICaviarChef(caviarChef).seedRewards(_amountStaking);
        
        if(pairSecondRewarder != address(0)) {
            IERC20(caviar).safeTransfer(pairSecondRewarder, _amountSecondReward);
        }
    }

    function emergencyWithdraw(address _token) external onlyOwner {
        uint256 _balance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).safeTransfer(msg.sender, _balance);
    }
}
