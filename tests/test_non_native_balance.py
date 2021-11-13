from brownie import (
    accounts,
    interface,
    HelperRegistry
)
from brownie import *
from pytest import approx

# tests
# take an account
# deposit in multiple setts from that account
# then use the calc_withdraw_one_coin function for each sett & add them all up to get his wbtc balance for all the setts
# finally use the non-native balance function and assert that this equals the above total calc_withdraw_one_coin value


def test_non_native_balance(crv_helpers, crv_whales, wbtc_index, precision):
    voter = accounts[4]
    owner = accounts[0]
    # deploy the registry
    registry = HelperRegistry.deploy({"from": owner})
    expected_wbtc_val = 0
    for i in range(0, len(crv_helpers)):
        expected_wbtc_val += setup_helper(owner, voter, registry,
                                          crv_whales[i], crv_helpers[i], wbtc_index[i], precision[i])

    # now get the balance from the helper registry
    actual_wbtc_val = registry.getNonNativeBalance(voter)

    assert approx(actual_wbtc_val, rel=1e-1) == expected_wbtc_val


def setup_helper(owner, voter, registry, crv_whale, crv_helper, wbtc_index, precision):
    whale = accounts.at(
        crv_whale, force=True)
    # deploy the helper for the sett
    helper = crv_helper.deploy({"from": owner})
    # add the helper to the registry
    registry.addHelper(helper, {"from": owner})

    sett = interface.ISettV3(helper.SETT())
    curve = interface.ICurveExchange(helper.CURVE_POOL())
    lp = interface.IERC20(helper.lp())

    want_amt = int(lp.balanceOf(whale) * 0.1)
    # transfer the lp from the whale to the voter so that he can deposit it to the sett
    lp.transfer(voter, want_amt, {"from": whale})

    lp.approve(sett, want_amt, {"from": voter})
    sett.deposit(want_amt, {"from": voter})

    expected_wbtc_val = curve.calc_withdraw_one_coin(
        want_amt, wbtc_index) / precision

    return expected_wbtc_val
