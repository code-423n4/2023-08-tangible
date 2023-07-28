// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;
interface IVoter {

    function claimFees(address[] memory _fees, address[][] memory _tokens, uint _tokenId) external;
    function claimBribes(address[] memory _bribes, address[][] memory _tokens, uint _tokenId) external;
    function vote(uint tokenId, address[] calldata _poolVote, uint256[] calldata _weights) external;
    function reset(uint _tokenId) external;
}
