// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IERC20.sol";

contract CSAMM
{
    /**
     * State Variables
     */
    // first token in the liquidity pool
    IERC20 public immutable token0;
    // second token in the liquidity pool
    IERC20 public immutable token1;

    // keeps track of the amount of token0 in this contract
    uint256 public reserve0;
    // keeps track of the amount of token1 in this contract
    uint256 public reserve1;

    // keeps track of the entire amount of tokens in the contract
    uint256 public totalSupply;

    // mapping from user to the amount of shares of the liquidity pool they currently have
    // user -> shares
    mapping (address => uint256) balanceOf;

    constructor(address _token0, address _token1)
    {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function swap() external
    {

    }

    function addLiquidity() external
    {

    }

    function removeLiquidity() external
    {

    }
}