// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../interfaces/IEIP6170.sol";
import {IMessageRecipient} from "../interface/IMessageRecipient.sol";

/// @notice will handle all the message delivery from hyperlane's mailbox
/// @dev will use hyperlane's built-in ISM
/// TODO: Provisions for custom ISM
abstract contract ReceiverImpl is IEIP6170, IMessageRecipient, Getter {
    /// @dev see IMessageRecipient-{handle}
    function handle(
        uint32 origin_,
        bytes32 sender_,
        bytes calldata messageBody_
    ) external override {
        require(msg.sender == getMailbox());

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = messageBody_;
        bytes memory sender = abi.encode(sender_);
        bytes memory chainId = getEIPChainId(origin_);

        receiveMessage(chainId, sender, message, bytes(""));
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
        require(msg.sender == getMailbox());
    }
}
