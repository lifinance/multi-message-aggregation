pragma solidity ^0.8.19;

import "./State.sol";

contract Getter is State {
    /// @dev retrieves the gateway address
    function getGateway() public view returns (address) {
        return _state.gateway;
    }

    /// @dev retrieves the gas service address
    function getGasService() public view returns (address) {
        return _state.gasService;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(
        bytes memory eipChainId_
    ) public view returns (string memory) {
        return _state.inherentChainId[eipChainId_];
    }

    /// @dev retrieves the eip specific chain id
    function getEIPChainId(
        string memory _ambChainId
    ) public view returns (bytes memory) {
        return _state.eipChainId[_ambChainId];
    }
}
