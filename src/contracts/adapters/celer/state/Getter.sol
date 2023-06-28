pragma solidity ^0.8.19;

import "./State.sol";

contract Getter is State {
    /// @dev retrieves the message bus address
    function getMessageBus() public view returns (address) {
        return _state.messageBus;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(
        bytes memory lifiChainId_
    ) public view returns (uint64) {
        return _state.inherentChainId[lifiChainId_];
    }

    /// @dev retrieves the eip specific chain id
    function getLIFIChainId(
        uint64 _ambChainId
    ) public view returns (bytes memory) {
        return _state.lifiChainId[_ambChainId];
    }
}
