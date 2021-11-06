from brownie import (
    BcrvRenBTCHelper,
    BcrvSBTCHelper,
    BcrvTBTCHelper
)
from brownie import *
import pytest


@pytest.fixture
def helpers():
    return [BcrvRenBTCHelper, BcrvSBTCHelper, BcrvTBTCHelper]


@pytest.fixture
def whales():
    return ["0xc77c6375e9fd581701425a6fb70bf371fb1cba28", "0x1f08863f246fe456f94579d1a2009108b574f509", "0x3d24d77bec08549d7ea86c4e9937204c11e153f1"]


@pytest.fixture
def wbtc_index():
    return [1, 1, 0]


# needed for pools where the final amount out is not in 8 decimals
@pytest.fixture
def precision():
    return [1, 1, 1e10]
