// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface INativeBalance {
    /// @notice get the badger & digg balance in wbtc denomination using uniswapV2 pools 
    /// @param _account address of the account for which to get the balance
    function getNativeBalanceV2(address _account) external view returns (uint);

    /// @notice get the badger & digg balance in wbtc denomination using uniswapV3 pools 
    /// @param _account address of the account for which to get the balance
    function getNativeBalanceV3(address _account) external view returns (uint);
}