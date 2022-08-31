// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IERC20.sol";

/**
 * @dev A Constant Sum Automated Market Maker contract for ERC-20 tokens.
 * An automated market maker (AMM) is a decentralized exchange where the 
 * price of tokens is determined by a mathematical equation defined inside
 * the smart contract. This is in contrast to a centralized exchange, where the
 * price of the tokens is determined by the traders or centralized entities.
 * There are 3 fundamental things you can do with this AMM:
 *  1. Add Liquidity - liquidity providers (users) can deposit tokens into the trading
 *  pair pool. When they add liquidity to the pool, they receive newly minted shares 
 *  which are units that determine what percentage of the liquidity pool they own.
 *  2. Swap Tokens - users can swap one token for another
 *  3. Remove liquidity - users can redeem their shares for their tokens back, when they
 *  remove liquidity from the pool, an amount of their shares proportional to how much
 *  liquidity they removed are burned.
 * The price of the tokens in this contract is determined by the formula:
 * X + Y = K
 * Where X is the amount of token A in the AMM and Y is the amount of token B in the AMM
 * when you add these 2 amount of tokens together, you get a constant K.
 */
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

    /**
     * @dev private function to mint shares to the liquidity provider (user)
     * @param _to The user's address where the shares will be minted to
     * @param _amount The amount of shares to mint
     */
    function _mint(address _to, uint256 _amount) private
    {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }
    /**
     * @dev private function to burn shares from the user that withdraws
     * @param _from The user's address where the shares will be burned from
     * @param _amount The amount of shares to burn
     */
    function _burn(address _from, uint256 _amount) private
    {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }
    /**
     * @dev private function to update the reserves when a user makes a swap
     * @param _res0 The new reserve 0
     * @param _res1 The new reserve 1
     */
    function _update(uint256 _res0, uint256 _res1) private
    {
        reserve0 = _res0;
        reserve1 = _res1;
    }
    /**
     * @dev function to swap one token for another from the liquidity pool
     * 
     */
    function swap(address _tokenIn, uint256 _amountIn) external returns(uint256 amountOut)
    {
        require(
        _tokenIn == address(token0) || _tokenIn == address(token1),
        "invalid token for this pool"
        );

        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint256 resIn, uint256 resOut) 
        = 
        isToken0 ? (token0, token1, reserve0, reserve1) : (token1, token0, reserve1, reserve0);

        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint256 amountIn = tokenIn.balanceOf(address(this)) - resIn;

        // smart contract takes a 0.3% fee
        amountOut = (amountIn * 997) / 1000;
        
        // update reserve0 and reserve1
        (uint256 res0, uint256 res1) = isToken0
        ? (resIn + _amountIn, resOut - amountOut)
        : (resOut - amountOut, resIn + _amountIn);
        _update(res0, res1);

        tokenOut.transfer(msg.sender, amountOut);
    }

    function addLiquidity() external
    {

    }

    function removeLiquidity() external
    {

    }
}