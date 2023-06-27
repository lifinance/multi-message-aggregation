// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {IMessageReceiver} from "../interface/IMessageReceiver.sol";

/// @notice will handle all the message delivery from celer's message bus
abstract contract ReceiverImpl is IEIP6170, IMessageReceiver, Getter {
    /// @dev see IMessageReceiver-{executeMessage}
    function executeMessage(
        address _srcContract,
        uint64 _srcChainId,
        bytes calldata _message,
        address // executor
    ) external payable override returns (ExecutionStatus) {
        require(msg.sender == getMessageBus());

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = _message;
        bytes memory sender = abi.encode(_srcContract);
        bytes memory chainId = getLIFIChainId(_srcChainId);

        receiveMessage(chainId, sender, message, bytes(""));
        return ExecutionStatus.Success;
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
        require(msg.sender == getMessageBus());
    }
}
