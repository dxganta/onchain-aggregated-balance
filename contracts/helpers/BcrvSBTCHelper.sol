// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract BcrvSBTCHelper is IHelper {

    address public constant CURVE_POOL = 0x7fC77b5c7614E1533320Ea6DDc2Eb61fa00A9714;
    address public constant SETT = 0xd04c48A53c111300aD41190D63681ed3dAd998eC;
    address public constant lp = 0x075b1bb99792c9E1041bA13afEf80C91a1e70fB3;


    function getBalanceInWbtc(address _account) public view returns (uint256) {
        uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;

        // didn't use a for loop to save gas
        uint256 wbtcReserve = ICurveExchange(CURVE_POOL).balances(0) + ICurveExchange(CURVE_POOL).balances(1) + (ICurveExchange(CURVE_POOL).balances(2) / 1e10); // dividing by 1e10 bcoz sbtc has 18 decimals

        return  (wbtcReserve * wantAmt )/ IERC20(lp).totalSupply();
    }
}