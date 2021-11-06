// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";
import "../../interfaces/token/IERC20.sol";

contract BcrvOBTCHelper is IHelper {

    address public constant CURVE_POOL = 0xd81dA8D904b52208541Bade1bD6595D8a251F8dd;
    address public constant SETT = 0xf349c0faA80fC1870306Ac093f75934078e28991;
    address public constant lp = 0x2fE94ea3d5d4a175184081439753DE15AeF9d614;

    function getBalanceInWbtc(address _account) public view returns (uint256) {
        uint256 wantAmt = ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare();

        // didn't use a for loop to save gas
        uint256 wbtcReserve = ICurveExchangeMeta(CURVE_POOL).balances(0) + ICurveExchangeMeta(CURVE_POOL).balances(1); // dividing by 1e10 bcoz hbtc has 18 decimals

        return  ((wbtcReserve * wantAmt) / 1e28)/ IERC20(lp).totalSupply();
    }
}