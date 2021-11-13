// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IHelperRegistry {

    /// @notice return addresses of all the registered helpers
    function getBalanceHelpers() external view returns (address[] memory);

    /// @notice get the total non-native balance of an account in wbtc denomination
    /// @param _account address of the account for which to get the balance
    function getNonNativeBalance(address _account) external view returns (uint total);
}