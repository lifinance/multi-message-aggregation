pragma solidity ^0.8.19;

import "./State.sol";

contract Getter is State {
    /// @dev retrieves the message bus address
    function getGate() public view returns (address) {
        return _state.gate;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(
        bytes memory _eipChainId
    ) public view returns (uint256) {
        return _state.inherentChainId[_eipChainId];
    }

    /// @dev retrieves the eip specific chain id
    function getLIFIChainId(
        uint256 _ambChainId
    ) public view returns (bytes memory) {
        return _state.eipChainId[_ambChainId];
    }
}
