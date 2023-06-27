// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {ITelepathyHandler} from "../interface/ITelepathyHandler.sol";

/// @notice will handle all the message delivery from telepathy's router
abstract contract ReceiverImpl is IEIP6170, ITelepathyHandler, Getter {
    /// @dev see ITelepathyHandler-{execute}
    function handleTelepathy(
        uint32 _sourceChainId,
        address _sourceAddress,
        bytes memory _data
    ) external override returns (bytes4) {
        require(msg.sender == getRouter());

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = _data;
        bytes memory sender = abi.encode(_sourceAddress);
        bytes memory chainId = getEIPChainId(_sourceChainId);

        receiveMessage(chainId, sender, message, bytes(""));

        return ITelepathyHandler.handleTelepathy.selector;
    }

    /// @dev see IEIP6170-{receiveMessage}
    /// note: override this function to receive message
    /// note: emit MessageReceived event on successful message delivery
    function receiveMessage(
        bytes memory _chainId,
        bytes memory _sender,
        bytes memory _message,
        bytes memory _data
    ) public virtual override returns (bool) {
        /// FIXME: add required validations here
        require(msg.sender == getRouter());
    }
}
