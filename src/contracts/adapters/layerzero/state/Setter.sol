/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import "./State.sol";

/// @title Setter
/// @dev got all setter functions to update state of LayerZero adapter
contract Setter is State {
    /// @dev sets the chain id
    function setChainId(
        uint16 _ambChainId,
        bytes memory _lifiChainId
    ) internal {
        _state.inherentChainId[_lifiChainId] = _ambChainId;
        _state.lifiChainId[_ambChainId] = _lifiChainId;
    }

    /// @dev sets the layerzero endpoint
    function setEndpoint(address _endpoint) internal {
        _state.endpoint = _endpoint;
    }

    /// @dev sets the gac addresss
    function setGac(address _gac) internal {
        _state.gac = _gac;
    }

    /// @dev sets the trusted remote
    function setTrustedRemote(
        uint16 _remoteChainId,
        bytes calldata _path
    ) internal {
        _state.trustedRemoteLookup[_remoteChainId] = _path;
    }

    /// @dev sets the nonce as used
    function setNonceUsed(uint64 _nonce) internal {
        _state.nonceUsed[_nonce] = true;
    }
}
