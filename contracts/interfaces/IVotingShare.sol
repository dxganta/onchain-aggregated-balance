// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IVotingShare {
    function balanceOf(address _voter) external view returns (uint256);
}