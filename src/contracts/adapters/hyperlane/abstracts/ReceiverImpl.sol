// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {IMessageRecipient} from "../interface/IMessageRecipient.sol";

/// @notice will handle all the message delivery from hyperlane's mailbox
/// @dev will use hyperlane's built-in ISM
/// TODO: Provisions for custom ISM
abstract contract ReceiverImpl is IEIP6170, IMessageRecipient, Getter {
    /// @dev see IMessageRecipient-{handle}
    function handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _messageBody
    ) external override {
        require(msg.sender == getMailbox());

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = _messageBody;
        bytes memory sender = abi.encode(_sender);
        bytes memory chainId = getEIPChainId(_origin);

        receiveMessage(chainId, sender, message, bytes(""));
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
        require(msg.sender == getMailbox());
    }
}
