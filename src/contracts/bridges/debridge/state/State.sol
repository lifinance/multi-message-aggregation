pragma solidity ^0.8.19;

contract Storage {
    struct DeBridgeStorage {
        /// @dev is the admin for sensitive smart contract changes
        address controller;
        /// @dev is the message gate of de-bridge
        address gate;
        /// @dev is the chainid of the amb
        mapping(bytes => uint256) inherentChainId;
        /// @dev is the reverse of `inherentChainId` mapping
        mapping(uint256 => bytes) eipChainId;
    }
}

contract State {
    Storage.DeBridgeStorage _state;
}
