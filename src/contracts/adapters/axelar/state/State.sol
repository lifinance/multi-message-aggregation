pragma solidity ^0.8.19;

contract Storage {
    struct AxelarStorage {
        /// @dev is the admin for sensitive smart contract changes
        address controller;
        /// @dev is the gateway of axelar
        address gateway;
        /// @dev is the gas service address of axelar
        address gasService;
        /// @dev is the chainid of the amb
        mapping(bytes => string) inherentChainId;
        /// @dev is the reverse of `inherentChainId` mapping
        mapping(string => bytes) eipChainId;
    }
}

contract State {
    Storage.AxelarStorage _state;
}
