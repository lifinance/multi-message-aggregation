// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {IMessageReceiver} from "../interface/IMessageReceiver.sol";

/// @notice will handle all the message delivery from hyperlane's mailbox
/// @dev will use hyperlane's built-in ISM
/// TODO: Provisions for custom ISM
abstract contract ReceiverImpl is IEIP6170, IMessageReceiver, Getter {
    /// @dev see IMessageReceiver-{executeMessage}
    function executeMessage(
        address srcContract_,
        uint64 srcChainId_,
        bytes calldata message_,
        address // executor
    ) external payable override returns (ExecutionStatus) {
        require(msg.sender == getMessageBus());

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = message_;
        bytes memory sender = abi.encode(srcContract_);
        bytes memory chainId = getEIPChainId(srcChainId_);

        receiveMessage(chainId, sender, message, bytes(""));
        return ExecutionStatus.Success;
    }

    /// @dev see IEIP6170-{receiveMessage}
    /// note: override this function to receive message
    /// note: emit MessageReceived event on successful message delivery
    function receiveMessage(
        bytes memory chainId_,
        bytes memory sender_,
        bytes memory message_,
        bytes memory data_
    ) public virtual override returns (bool) {
        /// FIXME: add required validations here
        require(msg.sender == getMessageBus());
    }
}
