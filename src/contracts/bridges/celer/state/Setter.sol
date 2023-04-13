pragma solidity ^0.8.19;

import "./State.sol";

contract Setter is State {
    function setChainId(uint64 ambChainId_, bytes memory eipChainId_) internal {
        _state.inherentChainId[eipChainId_] = ambChainId_;
        _state.eipChainId[ambChainId_] = eipChainId_;
    }

    function setMessageBus(address messageBus_) internal {
        _state.messageBus = messageBus_;
    }

    function setController(address controller_) internal {
        if (_state.controller != address(0)) {
            require(_state.controller == msg.sender);
        }
        _state.controller = controller_;
    }
}
