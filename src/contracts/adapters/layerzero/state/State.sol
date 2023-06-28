/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

/// @title Storage
/// @dev storage layout for LayerZero Adapter
contract Storage {
    struct LayerzeroState {
        /// @dev is the endpoint of LayerZero
        address endpoint;
        /// @dev is the address of GAC
        address gac;
        /// @dev is the chainid of the amb
        mapping(bytes => uint16) inherentChainId;
        /// @dev is the reverse of `inherentChainId` mapping
        mapping(uint16 => bytes) lifiChainId;
        /// @dev is the trusted remote mapping
        mapping(uint16 => bytes) trustedRemoteLookup;
        /// @dev maps used nonce
        mapping(uint64 => bool) nonceUsed;
    }
}

contract State {
    Storage.LayerzeroState _state;
}
