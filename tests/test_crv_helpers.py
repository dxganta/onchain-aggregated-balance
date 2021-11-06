from brownie import (
    accounts,
    interface,
)
from brownie import *
from pytest import approx


# test all the helpers in a loop
def test_crv_helpers(crv_helpers, crv_whales, wbtc_index, precision):
    for i in range(0, len(crv_helpers)):
        dev = accounts[0]
        whale = accounts.at(
            crv_whales[i], force=True)
        helper = crv_helpers[i].deploy({"from": dev})

        sett = interface.ISettV3(helper.SETT())
        curve = interface.ICurveExchange(helper.CURVE_POOL())
        lp = interface.IERC20(helper.lp())

        # make sure that the account has no prior deposits in the sett
        assert sett.balanceOf(whale) == 0

        # deposit want to sett
        want_amt = int(lp.balanceOf(whale) * 0.1)
        lp.approve(sett, want_amt, {"from": whale})
        sett.deposit(want_amt, {"from": whale})

        # convert the deposited lp to wbtc using curve
        expected_wbtc_val = curve.calc_withdraw_one_coin(
            want_amt, wbtc_index[i]) / precision[i]

        # get wbtc amt from helper
        actual_wbtc_val = helper.getBalanceInWbtc(whale)

        # assert it equals the deposited lp amt
        assert approx(actual_wbtc_val, rel=1e-1) == expected_wbtc_val
