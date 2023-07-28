// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CaviarChefRewardSeeder is OwnableUpgradeable {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    string public __NAME__;
    address public caviarChef;
    address public caviar;

    constructor() public {}

    function initialize(string memory _name, address _caviar) public initializer {
        __Ownable_init();
        __NAME__ = _name;
        caviar = _caviar;
    }

    modifier onlyChef() {
        require(msg.sender == caviarChef, "!auth");
        _;
    }

    function setCaviarChef(address _caviarChef) external onlyOwner {
        caviarChef = _caviarChef;
    }

    function claim(uint256 _pending, address _to) external onlyChef {
        require(IERC20(caviar).balanceOf(address(this)) >= _pending, "Amount exceeds balance");
        IERC20(caviar).safeTransfer(_to, _pending);
    }
}
