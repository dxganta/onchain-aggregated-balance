// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract TestHelper is IHelper {

    address public constant CURVE_POOL = 0x93054188d876f558f4a66B2EF1d97d16eDf0895B;
    address public constant SETT = 0x6dEf55d2e18486B9dDfaA075bc4e4EE0B28c1545;
    address public constant lp = 0x49849C98ae39Fff122806C06791Fa73784FB3675;

    uint test;

    function getBalanceInWbtc(address _account) public view returns (uint256) {
       uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;
       
       // convert want to wbtc amount using curve pool
        return ICurveExchange(CURVE_POOL).calc_withdraw_one_coin(wantAmt, 1);
    }

    function getBalanceInWbtcVP(address _account) public view returns (uint256) {
        uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare());

        return (wantAmt * ICurveExchange(CURVE_POOL).get_virtual_price()) / 1e36;
        
    }

    function getBalanceInWbtcShort(address _account) public view returns (uint256) {
        uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;

        // didn't use a for loop to save gas
        uint256 wbtcReserve = ICurveExchange(CURVE_POOL).balances(0) + ICurveExchange(CURVE_POOL).balances(1);

        return  (wbtcReserve * wantAmt )/ IERC20(lp).totalSupply();
    }

    function calculateGas(address _account) external {
        test = getBalanceInWbtc(_account);
    }

    function calculateGasVP(address _account) external {
        test = getBalanceInWbtcVP(_account);
    }

     function calculateGasShort(address _account) external {
        test = getBalanceInWbtcShort(_account);
    }
}