/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import "./State.sol";

/// @title Setter
/// @dev got all getter functions to read state of LayerZero adapter
contract Getter is State {
    /// @dev retrieves the mailbox address
    function getEndpoint() public view returns (address) {
        return _state.endpoint;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(bytes memory _eipChainId) public view returns (uint16) {
        return _state.inherentChainId[_eipChainId];
    }

    /// @dev retrieves the eip specific chain id
    function getLIFIChainId(
        uint16 _ambChainId
    ) public view returns (bytes memory) {
        return _state.eipChainId[_ambChainId];
    }

    /// @dev retrieves the eip specific chain id
    function getGac() public view returns (address) {
        return _state.gac;
    }

    /// @dev retrieves the trusted remote for srcChainId
    function getTrustedRemote(
        uint16 _srcChainId
    ) public view returns (bytes memory) {
        return _state.trustedRemoteLookup[_srcChainId];
    }

    /// @dev retrieves the trusted remote for srcChainId
    function getNonceStatus(uint64 _nonce) public view returns (bool) {
        return _state.nonceUsed[_nonce];
    }
}
