/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

contract Storage {
    struct HyperlaneState {
        /// @dev is the gac
        address gac;
        /// @dev is the mailbox of hyperlane
        address mailbox;
        /// @dev is the chainid of the amb
        mapping(bytes => uint32) inherentChainId;
        /// @dev is the reverse of `inherentChainId` mapping
        mapping(uint32 => bytes) lifiChainId;
        /// @dev maps the remote chain id to a path
        mapping(uint32 => bytes32) trustedRemoteLookup;
    }
}

contract State {
    Storage.HyperlaneState _state;
}
