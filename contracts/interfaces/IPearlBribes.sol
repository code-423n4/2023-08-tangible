// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

interface IPearlBribes {
  function rewardTokens() external view returns(address[] memory);
  function getReward(address[] memory tokens) external;
  function notifyRewardAmount(address _rewardsToken, uint256 reward) external;
}