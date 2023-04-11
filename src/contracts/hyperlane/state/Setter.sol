pragma solidity ^0.8.18;

import "./State.sol";

contract Setter is State {
    function setChainId(uint32 ambChainId_, bytes memory eipChainId_) internal {
        _state.inherentChainId[eipChainId_] = ambChainId_;
        _state.eipChainId[ambChainId_] = eipChainId_;
    }

    function setMailbox(address mailbox_) internal {
        _state.mailbox = mailbox_;
    }

    function setController(address controller_) internal {
        if (_state.controller != address(0)) {
            require(_state.controller == msg.sender);
        }
        _state.controller = controller_;
    }
}