// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract BcrvBBTCHelper is IHelper {

    address public constant CURVE_POOL = 0x071c661B4DeefB59E2a3DdB20Db036821eeE8F4b;
    address public constant SETT = 0x5Dce29e92b1b939F8E8C60DcF15BDE82A85be4a9;
    address public constant lp = 0x410e3E86ef427e30B9235497143881f717d93c2A;

    function getBalanceInWbtc(address _account) public view returns (uint256) {
        uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;

        // didn't use a for loop to save gas
        uint256 wbtcReserve = ICurveExchangeMeta(CURVE_POOL).balances(0) + (ICurveExchangeMeta(CURVE_POOL).balances(1) / 1e10); 

        return  (wbtcReserve * wantAmt)/ IERC20(lp).totalSupply();
    }
}