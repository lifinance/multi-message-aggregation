pragma solidity ^0.8.19;

import "./State.sol";

contract Setter is State {
    function setChainId(
        uint64 _ambChainId,
        bytes memory _lifiChainId
    ) internal {
        _state.inherentChainId[_lifiChainId] = _ambChainId;
        _state.lifiChainId[_ambChainId] = _lifiChainId;
    }

    function setMessageBus(address _gate) internal {
        _state.gate = _gate;
    }

    function setController(address _controller) internal {
        if (_state.controller != address(0)) {
            require(_state.controller == msg.sender);
        }
        _state.controller = _controller;
    }
}
