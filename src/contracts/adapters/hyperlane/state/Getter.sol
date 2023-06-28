/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import "./State.sol";

/// @title Getter
/// @dev got all getter functions to read state of Hyperlane adapter
contract Getter is State {
    /// @dev retrieves the mailbox address
    function getMailbox() public view returns (address) {
        return _state.mailbox;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(
        bytes memory _lifiChainId
    ) public view returns (uint32) {
        return _state.inherentChainId[_lifiChainId];
    }

    /// @dev retrieves the eip specific chain id
    function getLIFIChainId(
        uint32 _ambChainId
    ) public view returns (bytes memory) {
        return _state.lifiChainId[_ambChainId];
    }

    /// @dev retrieves the gac address
    function getGac() public view returns (address) {
        return _state.gac;
    }

    /// @dev retrieves the trusted remote
    function getTrustedRemote(
        uint32 _srcChainId
    ) public view returns (bytes32) {
        return _state.trustedRemoteLookup[_srcChainId];
    }
}
