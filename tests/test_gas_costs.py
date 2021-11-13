from brownie import (
    accounts,
    interface,
    HelperRegistry,
    StakeRatioGas,
    NativeBalance
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
    for i in range(0, len(crv_helpers)):
        setup_helper(owner, voter, registry,
                     crv_whales[i], crv_helpers[i], wbtc_index[i], precision[i])

    badger = interface.IERC20("0x3472A5A71965499acd81997a54BBA8D852C6E53d")
    digg = interface.IERC20("0x798d1be841a82a273720ce31c822c61a67a601c3")
    badger_whale = accounts.at(
        "0x34e2741a3f8483dbe5231f61c005110ff4b9f50a", force=True)
    digg_whale = accounts.at(
        "0x95eec544a7cf2e6a65a71039d58823f4564a6319", force=True)
    # transfer some badgers & diggs to the voter to get a native balance
    badger.transfer(voter, badger.balanceOf(
        badger_whale), {"from": badger_whale})
    digg.transfer(voter, badger.balanceOf(digg_whale), {"from": digg_whale})

    # deploy native balance contract
    native_balance_contract = NativeBalance.deploy({"from": owner})

    # deploy gas calculating contract
    gas_contract = StakeRatioGas.deploy(
        native_balance_contract, registry, {"from": owner})

    gas_contract.nativeBalanceGas(voter, {"from": voter})
    gas_contract.nonNativeBalanceGas(voter, {"from": voter})
    gas_contract.stakeRatioGas(voter, {"from": voter})


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
