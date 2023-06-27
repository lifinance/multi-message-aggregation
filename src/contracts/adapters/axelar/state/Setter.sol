pragma solidity ^0.8.19;

import "./State.sol";

contract Setter is State {
    function setChainId(
        string memory _ambChainId,
        bytes memory _eipChainId
    ) internal {
        _state.inherentChainId[_eipChainId] = _ambChainId;
        _state.eipChainId[_ambChainId] = _eipChainId;
    }

    function setGateway(address _gateway) internal {
        _state.gateway = _gateway;
    }

    function setGasService(address _gasService) internal {
        _state.gasService = _gasService;
    }

    function setController(address _controller) internal {
        if (_state.controller != address(0)) {
            require(_state.controller == msg.sender);
        }
        _state.controller = _controller;
    }
}
