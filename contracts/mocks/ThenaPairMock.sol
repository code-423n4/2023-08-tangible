// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

contract PearlPairMock {
  address public token0;
  address public token1;
  uint256 public reserve0;
  uint256 public reserve1;

  constructor() public {}

  function setTokens(address _token0, address _token1) external {
    token0 = _token0;
    token1 = _token1;
  }

  function setReserves(uint256 _reserve0, uint256 _reserve1) external {
    reserve0 = _reserve0;
    reserve1 = _reserve1;
  }
}
