// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract BcrvTBTCHelper is IHelper {

    address public constant CURVE_POOL = 0xC25099792E9349C7DD09759744ea681C7de2cb66;
    address public constant SETT = 0xb9D076fDe463dbc9f915E5392F807315Bf940334;
    address public constant lp = 0x64eda51d3Ad40D56b9dFc5554E06F94e1Dd786Fd;


    function getBalanceInWbtc(address _account) public view returns (uint256) {
        uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;

        // didn't use a for loop to save gas
        uint256 wbtcReserve = (ICurveExchangeMeta(CURVE_POOL).balances(0) + ICurveExchangeMeta(CURVE_POOL).balances(1)) / 1e10;

        return  (wbtcReserve * wantAmt )/ IERC20(lp).totalSupply();
    }
}