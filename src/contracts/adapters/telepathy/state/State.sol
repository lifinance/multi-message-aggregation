pragma solidity ^0.8.19;

contract Storage {
    struct TelepathyState {
        /// @dev is the admin for sensitive state changes
        address controller;
        /// @dev is the router of telepathy
        address router;
        /// @dev is the chainid of the amb
        mapping(bytes => uint32) inherentChainId;
        /// @dev is the reverse of `inherentChainId` mapping
        mapping(uint32 => bytes) eipChainId;
    }
}

contract State {
    Storage.TelepathyState _state;
}
