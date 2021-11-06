from brownie import (
    accounts,
    interface,
    BcrvTricrypto2Helper
)
from brownie import *
from pytest import approx


# test all the helpers in a loop
def test_tricrypto_helper():
    dev = accounts[0]
    whale = accounts.at(
        "0xee1f07f88934c2811e3dcabdf438d975c3d62cd3", force=True)
    helper = BcrvTricrypto2Helper.deploy({"from": dev})

    sett = interface.ISettV3(helper.SETT())
    curve = interface.ICurveExchangeMeta(helper.CURVE_POOL())
    lp = interface.IERC20(helper.lp())

    # make sure that the account has no prior deposits in the sett
    assert sett.balanceOf(whale) == 0

    # deposit want to sett
    want_amt = int(lp.balanceOf(whale) * 0.1)
    lp.approve(sett, want_amt, {"from": whale})
    sett.deposit(want_amt, {"from": whale})

    # convert the deposited lp to wbtc using curve
    expected_wbtc_val = curve.calc_withdraw_one_coin(
        want_amt, 1)

    # get wbtc amt from helper
    actual_wbtc_val = helper.getBalanceInWbtc(whale)

    # assert it equals the deposited lp amt
    assert approx(actual_wbtc_val, rel=1e-1) == expected_wbtc_val
