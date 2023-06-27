pragma solidity ^0.8.19;

import "./State.sol";

contract Getter is State {
    /// @dev retrieves the mailbox address
    function getEndpoint() public view returns (address) {
        return _state.endpoint;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(bytes memory _eipChainId) public view returns (uint16) {
        return _state.inherentChainId[_eipChainId];
    }

    /// @dev retrieves the eip specific chain id
    function getEIPChainId(
        uint16 _ambChainId
    ) public view returns (bytes memory) {
        return _state.eipChainId[_ambChainId];
    }
}
