pragma solidity ^0.8.18;

contract Storage {
    struct LayerzeroState {
        /// @dev is the admin for sensitive state changes
        address controller;
        /// @dev is the endpoint of layezero
        address endpoint;
        /// @dev is the chainid of the amb
        mapping(bytes => uint16) inherentChainId;
        /// @dev is the reverse of `inherentChainId` mapping
        mapping(uint16 => bytes) eipChainId;
    }
}

contract State {
    Storage.LayerzeroState _state;
}
