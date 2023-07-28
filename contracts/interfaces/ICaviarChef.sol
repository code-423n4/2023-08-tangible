// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICaviarChef {
    function balanceOf() external view returns(uint256);
    function userInfo(address _user) external view returns (uint256, uint256);
    function deposit(uint256 amount, address to) external;
    function harvest(address to) external;
    function underlying() external view returns (IERC20);
    function seedRewards(uint256 _amount) external;
}