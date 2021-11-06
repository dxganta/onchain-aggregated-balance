from brownie import (
    BcrvRenBTCHelper,
    BcrvSBTCHelper
)
from brownie import *
import pytest


@pytest.fixture
def helpers():
    return [BcrvRenBTCHelper, BcrvSBTCHelper]


@pytest.fixture
def whales():
    return ["0xc77c6375e9fd581701425a6fb70bf371fb1cba28", "0x1f08863f246fe456f94579d1a2009108b574f509"]
