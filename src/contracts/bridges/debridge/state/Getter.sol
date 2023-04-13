pragma solidity ^0.8.19;

import "./State.sol";

contract Getter is State {
    /// @dev retrieves the message bus address
    function getGate() public view returns (address) {
        return _state.gate;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(
        bytes memory eipChainId_
    ) public view returns (uint256) {
        return _state.inherentChainId[eipChainId_];
    }

    /// @dev retrieves the eip specific chain id
    function getEIPChainId(
        uint256 ambChainId_
    ) public view returns (bytes memory) {
        return _state.eipChainId[ambChainId_];
    }
}
