// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/BoringOwnable.sol";
import "./interfaces/IVotingShare.sol";
import "../interfaces/uniswapv2/IUniswapV2Pair.sol";
import "../interfaces/uniswapv3-core/IUniswapV3Pool.sol";

import "./libraries/TickMath.sol";

contract NativeBalance is BoringOwnable {

    address public DIGG_VOTING_SHARE = 0x47752Ff9d07EC7803694860566a83356A9eb5f51;
    address public BADGER_VOTING_SHARE = 0x210467513028b6Af4d03ea0a97A5727e3C1a03B8;
    address public BADGER_WBTC_V3_POOL = 0xe15e6583425700993bd08F51bF6e7B73cd5da91B;
    address public BADGER_WBTC_SUSHI_POOL = 0x110492b31c59716AC47337E616804E3E3AdC0b4a;
    address public DIGG_WBTC_SUSHI_POOL = 0x9a13867048e01c663ce8Ce2fE0cDAE69Ff9F35E3;

    uint32 public secondsAgo = 1300;
    uint128 public PRECISION = 10**18;
    /// @notice get the badger & digg balance in wbtc denomination using uniswapV2 pools 
    /// @param _account address of the account for which to get the balance
    function getNativeBalanceV2(address _account) public view returns (uint) {
        uint badgerBal = IVotingShare(BADGER_VOTING_SHARE).balanceOf(_account);
        uint diggBal = IVotingShare(DIGG_VOTING_SHARE).balanceOf(_account);
        
        // get badger balance in wbtc denomination from sushi pool
        (uint wbtcReserve,uint badgerReserve, ) =  IUniswapV2Pair(BADGER_WBTC_SUSHI_POOL).getReserves();
        badgerBal = (badgerBal * wbtcReserve * 10**18) / badgerReserve; 

        // get digg balance in wbtc denomination from sushi pool
        (uint wbtcDiggReserve, uint diggReserve, ) = IUniswapV2Pair(DIGG_WBTC_SUSHI_POOL).getReserves();
        diggBal = (diggBal * wbtcDiggReserve * 10**9) / diggReserve;

        return badgerBal + diggBal;
    }

    /// @notice get the badger & digg balance in wbtc denomination using uniswapV3 pools 
    /// @param _account address of the account for which to get the balance
    function getNativeBalanceV3(address _account) public view returns (uint) {
        uint badgerBal = IVotingShare(BADGER_VOTING_SHARE).balanceOf(_account);
        uint diggBal = IVotingShare(DIGG_VOTING_SHARE).balanceOf(_account);

        // get badger balance in wbtc denomination from uniswap v3 pool
        uint32[] memory secondsAgos = new uint32[](2);
        secondsAgos[0] = secondsAgo;
        secondsAgos[1] = 0;
        (int56[] memory tickCumulatives, ) = IUniswapV3Pool(BADGER_WBTC_V3_POOL).observe(secondsAgos);

        int24 tick = int24((tickCumulatives[1] - tickCumulatives[0]) / int32(secondsAgo));
        // TickMath.getSqrtRatioAtTick(tick) returns sqrt(1.0001^tick) * 2^96
        uint tickToPrice = (TickMath.getSqrtRatioAtTick(tick) / 2**96) **2; 
        badgerBal = 10**18 / tickToPrice; // badgerBal in wbtc denomination

        // get digg balance in wbtc denomination from sushi pool
        (uint wbtcDiggReserve, uint diggReserve, ) = IUniswapV2Pair(DIGG_WBTC_SUSHI_POOL).getReserves();
        diggBal = (diggBal * wbtcDiggReserve * 10**9) / diggReserve;

        return badgerBal + diggBal;

    }
}