// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IHelper {
    function getBalanceInWbtc(address _account) external view returns (uint256);
}