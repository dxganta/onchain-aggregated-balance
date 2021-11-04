from brownie import (
    accounts,
    interface,
    BcrvRenBTCHelper
)
from brownie import *
from pytest import approx


def test_bcrvcrvRenBtcHelper():
    crvRenBtc = interface.IERC20("0x49849c98ae39fff122806c06791fa73784fb3675")
    crvRenBtc_whale = accounts.at(
        "0xc77c6375e9fd581701425a6fb70bf371fb1cba28", force=True)
    dev = accounts[0]
    bcrvcrvRenBtcHelper = BcrvRenBTCHelper.deploy({"from": dev})

    sett = interface.ISettV3(bcrvcrvRenBtcHelper.SETT())
    curve = interface.ICurveExchange(bcrvcrvRenBtcHelper.CURVE_POOL())

    # make sure that the account has no prior deposits in the sett
    assert sett.balanceOf(crvRenBtc_whale) == 0

    # deposit want to sett
    crvRenBtc_amt = int(crvRenBtc.balanceOf(crvRenBtc_whale) * 0.1)
    crvRenBtc.approve(sett, crvRenBtc_amt, {"from": crvRenBtc_whale})
    sett.deposit(crvRenBtc_amt, {"from": crvRenBtc_whale})

    # get wbtc amt from helper
    actual_wbtc_val = bcrvcrvRenBtcHelper.getBalanceInWbtc(crvRenBtc_whale)

    # convert the deposited crvRenBtc to wbtc using curve
    expected_wbtc_val = curve.calc_withdraw_one_coin(crvRenBtc_amt, 1)

    # assert it equals the deposited crvRenBtc amt
    assert approx(actual_wbtc_val) == expected_wbtc_val
