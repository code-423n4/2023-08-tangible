// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ICaviarFeeManager {
    function distributeFees() external;
    function distributeRebaseFees(uint) external;
}