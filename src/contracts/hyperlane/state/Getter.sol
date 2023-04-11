pragma solidity ^0.8.18;

import "./State.sol";

contract Getter is State {
    /// @dev retrieves the mailbox address
    function getMailbox() public view returns (address) {
        return _state.mailbox;
    }

    /// @dev retrieves the amb specific chain id
    function getChainId(bytes memory eipChainId_) public view returns (uint32) {
        return _state.inherentChainId[eipChainId_];
    }

    /// @dev retrieves the eip specific chain id
    function getEIPChainId(
        uint32 ambChainId_
    ) public view returns (bytes memory) {
        return _state.eipChainId[ambChainId_];
    }
}
