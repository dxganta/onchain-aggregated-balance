// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../interfaces/BoringOwnable.sol";
import "./interfaces/IHelper.sol";

contract HelperRegistry is BoringOwnable {

    address[] private _helpers;

    event HelperAdded(address helper, uint index);
    event HelperRemoved(address helper, uint index);

    /// @notice add a new helper to the end of the array
    /// @param _helper address of the helper contract
    function addHelper(address _helper) external onlyOwner {
        _helpers.push(_helper);
        emit HelperAdded(_helper, _helpers.length);
    }

    /// @notice add a new helper to the the _helpers array at a particular index
    /// @param _helper address of the helper contract
    /// @param _index index of the array at which to add the helper contract
    function addHelper(address _helper, uint _index) external onlyOwner {
        _helpers[_index] = _helper;
        emit HelperAdded(_helper, _index);
    }

    /// @notice add new helpers to the _helpers array
    /// @param _newHelpers array containing the address of each helper contract
    function addHelpers(address[] memory _newHelpers) external onlyOwner {
        for (uint i = 0; i < _newHelpers.length; i++) {
            _helpers.push(_newHelpers[i]);
            emit HelperAdded(_newHelpers[i], _helpers.length);
        }
    }

    /// @notice remove a helper from the registry 
    /// @param _index index of the helper address in the _helpers array
    function removeHelper(uint _index) external onlyOwner {
        emit HelperRemoved(_helpers[_index], _index);
        delete _helpers[_index];
    }

    /// @notice return addresses of all the registered helpers
    function getBalanceHelpers() public view returns (address[] memory) {
        return _helpers;
    }

    /// @notice get the total non-native balance of an account in wbtc denomination
    /// @param _account address of the account for which to get the balance
    function getNonNativeBalance(address _account) public view returns (uint total) {
        for (uint i=0; i<_helpers.length; i++) {
            if (_helpers[i] != address(0)) {
                total += IHelper(_helpers[i]).getBalanceInWbtc(_account);
            }    
        }
    }
}