/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import "./State.sol";

/// @title Setter
/// @dev got all setter functions to update state of Hyperlane adapter
contract Setter is State {
    /// @dev sets the chain id
    function setChainId(
        uint32 _ambChainId,
        bytes memory _lifiChainId
    ) internal {
        _state.inherentChainId[_lifiChainId] = _ambChainId;
        _state.lifiChainId[_ambChainId] = _lifiChainId;
    }

    /// @dev sets the hyperlane mailbox
    function setMailbox(address _mailbox) internal {
        _state.mailbox = _mailbox;
    }

    /// @dev sets the gac addresss
    function setGac(address _gac) internal {
        _state.gac = _gac;
    }

    /// @dev sets the trusted remote
    function setTrustedRemote(uint32 _remoteChainId, bytes32 _path) internal {
        _state.trustedRemoteLookup[_remoteChainId] = _path;
    }
}
