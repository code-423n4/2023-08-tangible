// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface ICaviarManager {
    function disableRedeem() external;
    function getCurrentEpoch() external view returns (uint256);
}