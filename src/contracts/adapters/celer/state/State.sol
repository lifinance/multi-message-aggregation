pragma solidity ^0.8.19;

contract Storage {
    struct CelerStorage {
        /// @dev is the admin for sensitive smart contract changes
        address controller;
        /// @dev is the message bus of celer
        address messageBus;
        /// @dev is the chainid of the amb
        mapping(bytes => uint64) inherentChainId;
        /// @dev is the reverse of `inherentChainId` mapping
        mapping(uint64 => bytes) eipChainId;
    }
}

contract State {
    Storage.CelerStorage _state;
}
