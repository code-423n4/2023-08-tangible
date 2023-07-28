// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "./interfaces/ICaviarChef.sol";

contract CaviarCompounder is ERC20Upgradeable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using AddressUpgradeable for address;
    using SafeMathUpgradeable for uint256;

    IERC20Upgradeable public token;
    ICaviarChef public caviarChef;
    string public __NAME__;

    constructor() public {}

    function initialize(
        string memory _name, 
        address _caviar,
        address _caviarChef
    ) public initializer {
        __ERC20_init("acaviar", "acaviar");
        __Ownable_init();
        __ReentrancyGuard_init();
        token = IERC20Upgradeable(_caviar);
        caviarChef = ICaviarChef(_caviarChef);
        __NAME__ = _name;
    }

    function balanceNotInPool() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function balanceOfPool() public view returns (uint256 _balance) {
        (_balance, ) = caviarChef.userInfo(address(this));
    }

    function balance() public view returns (uint256 _balance) {
        _balance = balanceNotInPool().add(balanceOfPool());
    }

    function deposit(uint256 _amount) public nonReentrant {
        uint256 _pool = balance();
        uint256 _shares = 0;
        if (totalSupply() == 0) {
            _shares = _amount;
        } else {
            _shares = (_amount.mul(totalSupply())).div(_pool);
        }
        _mint(msg.sender, _shares);
    }

    function earn() public {
        caviarChef.harvest(address(this));
        uint256 _balance = balanceNotInPool();
        caviarChef.deposit(_balance, address(this));
    }

    // No rebalance implementation for lower fees and faster swaps
    function withdraw(uint256 _shares) public nonReentrant {
        uint256 r = (balance().mul(_shares)).div(totalSupply());
        _burn(msg.sender, _shares);

        token.safeTransfer(msg.sender, r);
    }

    function getRatio() public view returns (uint256) {
        if (totalSupply() == 0) return 0;
        return balance().mul(1e18).div(totalSupply());
    }
}