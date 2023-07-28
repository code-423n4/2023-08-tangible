// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

interface IRouter01 {
    struct route {
        address from;
        address to;
        bool stable;
    }
    function pairFor(address tokenA, address tokenB, bool stable) external view returns (address pair);
    function swapExactTokensForTokens(uint amountIn,uint amountOutMin,route[] calldata routes,address to,uint deadline) external returns (uint[] memory amounts);
    function addLiquidity(address tokenA,address tokenB,bool stable,uint amountADesired,uint amountBDesired,uint amountAMin,uint amountBMin,address to,uint deadline) external returns (uint amountA, uint amountB, uint liquidity);

}
