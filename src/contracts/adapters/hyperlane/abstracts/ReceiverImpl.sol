// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import "forge-std/console.sol";

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {IMessageRecipient} from "../interface/IMessageRecipient.sol";
import {Error} from "../../../libraries/Error.sol";

/// @title ReceiverImpl
/// @notice will handle all the message delivery from Hyperlane Mailbox
/// @dev will use hyperlane's built-in ISM
/// TODO: Provisions for custom ISM
abstract contract ReceiverImpl is IEIP6170, IMessageRecipient, Getter {
    /// @inheritdoc IMessageRecipient
    function handle(
        uint32 _origin,
        bytes32 _sender,
        bytes calldata _messageBody
    ) external override {
        /// @dev caller authentication
        if (msg.sender != getMailbox()) {
            revert Error.NOT_HYPERLANE_MAILBOX();
        }

        console.logBytes32(_sender);
        console.logBytes32(getTrustedRemote(_origin));
        console.log(_origin);

        /// @dev sender authentication
        if (
            keccak256(abi.encode(_sender)) !=
            keccak256(abi.encode(getTrustedRemote(_origin)))
        ) {
            revert Error.INVALID_SOURCE_SENDER();
        }

        /// note: casting calldata to memory
        bytes memory message = _messageBody;
        bytes memory sender = abi.encode(_sender);
        bytes memory chainId = getLIFIChainId(_origin);

        receiveMessage(chainId, sender, message, bytes(""));
    }

    /// @dev see IEIP6170-{receiveMessage}
    /// note: override this function to receive message
    /// note: emit MessageReceived event on successful message delivery
    function receiveMessage(
        bytes memory _chainId,
        bytes memory,
        bytes memory _message,
        bytes memory
    ) public virtual returns (bool) {}
}
