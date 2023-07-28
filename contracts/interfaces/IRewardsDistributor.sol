// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IRewardsDistributor {
    function checkpoint_token() external;
    function voting_escrow() external view returns(address);
    function checkpoint_total_supply() external;
    function claimable(uint _tokenId) external view returns (uint);
    function claim(uint _tokenId) external ;
}
