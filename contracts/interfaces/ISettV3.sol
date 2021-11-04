// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ISettV3 {
    function getPricePerFullShare() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);

    function deposit(uint256 _amount) external;
    function depositAll() external;
    function withdraw(uint256 _shares) external;
    function withdrawAll() external;
}