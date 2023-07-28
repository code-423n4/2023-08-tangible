// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

interface ISmartWalletWhitelist {
    function check(address) external view returns (bool);
}
