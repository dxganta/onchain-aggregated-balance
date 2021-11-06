// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract BcrvPBTCHelper is IHelper {

    address public constant CURVE_POOL = 0x7F55DDe206dbAD629C080068923b36fe9D6bDBeF;
    address public constant SETT = 0x55912D0Cf83B75c492E761932ABc4DB4a5CB1b17;
    address public constant lp = 0xDE5331AC4B3630f94853Ff322B66407e0D6331E8;

    function getBalanceInWbtc(address _account) public view returns (uint256) {
        uint256 wantAmt = ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare();

        // didn't use a for loop to save gas
        uint256 wbtcReserve = ICurveExchangeMeta(CURVE_POOL).balances(0) + ICurveExchangeMeta(CURVE_POOL).balances(1);

        return  ((wbtcReserve * wantAmt) / 1e28)/ IERC20(lp).totalSupply();
    }
}