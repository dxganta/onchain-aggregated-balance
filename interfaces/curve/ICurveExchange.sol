//  SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ICurveExchange {
    function calc_withdraw_one_coin(uint256 token_amount, int128 i) external view returns (uint256);
    function calc_token_amount(uint256[2] memory _amounts, bool is_deposit) external view returns (uint256);
    function balances(int128 i) external view returns (uint256);
    function get_virtual_price() external view returns (uint256);
}

// same as the above one, but this one has uint256 as parameter in the balances function
interface ICurveExchangeMeta {
    function calc_withdraw_one_coin(uint256 token_amount, int128 i) external view returns (uint256);
    function calc_token_amount(uint256[2] memory _amounts, bool is_deposit) external view returns (uint256);
    function balances(uint256 i) external view returns (uint256);
    function get_virtual_price() external view returns (uint256);
}