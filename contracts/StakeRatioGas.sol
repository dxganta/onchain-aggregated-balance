// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./interfaces/INativeBalance.sol";
import "./interfaces/IHelperRegistry.sol";

contract StakeRatioGas {
    address public NATIVE_BALANCE;
    address public HELPER_REGISTRY;
    uint public nonNativeBalance;
    uint public nativeBalance;
    uint public stakeRatio;
    uint PRECISION = 1e6;

    constructor(address _nativeBalance, address _helperRegistry) {
        NATIVE_BALANCE = _nativeBalance;
        HELPER_REGISTRY = _helperRegistry;
    }

    function nativeBalanceGas(address _voter) public {
        nativeBalance = INativeBalance(NATIVE_BALANCE).getNativeBalanceV2(_voter);
    }

    function nonNativeBalanceGas(address _voter) public {
        nonNativeBalance = IHelperRegistry(HELPER_REGISTRY).getNonNativeBalance(_voter);
    }

    function stakeRatioGas(address _voter) public {
        stakeRatio = ((INativeBalance(NATIVE_BALANCE).getNativeBalanceV2(_voter) * PRECISION) /IHelperRegistry(HELPER_REGISTRY).getNonNativeBalance(_voter)) / PRECISION;
    }
}