// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract BcrvHBTCHelper is IHelper {

    address public constant CURVE_POOL = 0x4CA9b3063Ec5866A4B82E437059D2C43d1be596F;
    address public constant SETT = 0x8c76970747afd5398e958bDfadA4cf0B9FcA16c4;
    address public constant lp = 0xb19059ebb43466C323583928285a49f558E572Fd;

    function getBalanceInWbtc(address _account) public view returns (uint256) {
        uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;

        // didn't use a for loop to save gas
        uint256 wbtcReserve = (ICurveExchangeMeta(CURVE_POOL).balances(0) / 1e10) + ICurveExchangeMeta(CURVE_POOL).balances(1); // dividing by 1e10 bcoz hbtc has 18 decimals

        return  (wbtcReserve * wantAmt )/ IERC20(lp).totalSupply();
    }
}