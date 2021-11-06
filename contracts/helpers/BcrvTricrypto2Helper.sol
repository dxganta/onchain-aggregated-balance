// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract BcrvTricrypto2Helper is IHelper {

    ICurveExchangeMeta public constant CURVE_POOL = ICurveExchangeMeta(0xD51a44d3FaE010294C616388b506AcdA1bfAAE46);
    address public constant SETT = 0x27E98fC7d05f54E544d16F58C194C2D7ba71e3B5;
    address public constant lp = 0xc4AD29ba4B3c580e6D59105FFf484999997675Ff;

    function getBalanceInWbtc(address _account) public view returns (uint256) {
        uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;
        uint256 wbtcPrice = CURVE_POOL.price_oracle(0);
        uint256 ethPrice = CURVE_POOL.price_oracle(1);

        // using price_oracle
        uint256 wbtcReserve = ((CURVE_POOL.balances(0) * 1e20) / wbtcPrice) + CURVE_POOL.balances(1) + (CURVE_POOL.balances(2) * ethPrice / wbtcPrice / 1e10); 

        return  (wbtcReserve * wantAmt)/ IERC20(lp).totalSupply();
    }
}