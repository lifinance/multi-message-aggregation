pragma solidity ^0.8.19;

import "./State.sol";

contract Setter is State {
    function setChainId(uint32 _ambChainId, bytes memory _eipChainId) internal {
        _state.inherentChainId[_eipChainId] = _ambChainId;
        _state.eipChainId[_ambChainId] = _eipChainId;
    }

    function setRouter(address router_) internal {
        _state.router = router_;
    }

    function setController(address controller_) internal {
        if (_state.controller != address(0)) {
            require(_state.controller == msg.sender);
        }
        _state.controller = controller_;
    }
}
