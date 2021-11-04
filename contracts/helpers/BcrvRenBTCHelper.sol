// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/IHelper.sol";
import "../interfaces/ISettV3.sol";
import "../../interfaces/curve/ICurveExchange.sol";

contract BcrvRenBTCHelper is IHelper {

    address public constant CURVE_POOL = 0x93054188d876f558f4a66B2EF1d97d16eDf0895B;
    address public constant SETT = 0x6dEf55d2e18486B9dDfaA075bc4e4EE0B28c1545;

    function getBalanceInWbtc(address _account) external view returns (uint256) {
       uint256 wantAmt = (ISettV3(SETT).balanceOf(_account) * ISettV3(SETT).getPricePerFullShare()) / 1e18;
       
       // convert want to wbtc amount using curve pool
        return ICurveExchange(CURVE_POOL).calc_withdraw_one_coin(wantAmt, 1);
    }
}