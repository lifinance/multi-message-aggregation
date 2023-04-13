pragma solidity ^0.8.19;

import "./State.sol";

contract Setter is State {
    function setChainId(
        string memory ambChainId_,
        bytes memory eipChainId_
    ) internal {
        _state.inherentChainId[eipChainId_] = ambChainId_;
        _state.eipChainId[ambChainId_] = eipChainId_;
    }

    function setGateway(address gateway_) internal {
        _state.gateway = gateway_;
    }

    function setGasService(address gasService_) internal {
        _state.gasService = gasService_;
    }

    function setController(address controller_) internal {
        if (_state.controller != address(0)) {
            require(_state.controller == msg.sender);
        }
        _state.controller = controller_;
    }
}
