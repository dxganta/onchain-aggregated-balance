from brownie import (
    accounts,
    HelperRegistry
)
from brownie import *
import brownie

AddressZero = "0x0000000000000000000000000000000000000000"


def test_helper_registry(crv_helpers):
    n = len(crv_helpers)
    owner = accounts[0]

    # deploy helper registry
    helperRegistry = HelperRegistry.deploy({"from": owner})

    # test adding a single helper
    helper1 = crv_helpers[0].deploy({"from": owner})
    # trying to add a helper from an account other than owner must fail
    with brownie.reverts():
        helperRegistry.addHelper(helper1, {"from": accounts[1]})
    helperRegistry.addHelper(helper1, {"from": owner})

    helpers = helperRegistry.getBalanceHelpers()
    assert helpers[0] == helper1

    # test adding a lot of helpers
    newHelpers = []
    for i in range(1, n):
        newHelper = crv_helpers[i].deploy({"from": owner})
        newHelpers.append(newHelper)

    with brownie.reverts():
        helperRegistry.addHelpers(newHelpers, {"from": accounts[2]})

    helperRegistry.addHelpers(newHelpers, {"from": owner})

    helpers = helperRegistry.getBalanceHelpers()

    for i in range(len(newHelpers)):
        # i+1 since we already added a single helper before this
        assert helpers[i+1] == newHelpers[i]

    # test removing a helper
    # lets try removing the helper at index 0
    with brownie.reverts():
        helperRegistry.removeHelper(0, {"from": accounts[3]})

    helperRegistry.removeHelper(0, {"from": owner})

    helpers = helperRegistry.getBalanceHelpers()
    assert helpers[0] == AddressZero

    # try putting a new helper at that index 0
    helper1New = crv_helpers[0].deploy({"from": owner})
    with brownie.reverts():
        helperRegistry.addHelper(helper1New, 0, {"from": accounts[4]})
    helperRegistry.addHelper(helper1New, 0, {"from": owner})

    helpers = helperRegistry.getBalanceHelpers()
    assert helpers[0] == helper1New
