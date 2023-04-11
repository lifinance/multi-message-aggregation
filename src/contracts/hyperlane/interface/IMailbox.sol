// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

/// @dev interface for sending messages using hyperlane.
interface IMailbox {
    /// @notice Allows to send message through hyperlane.
    /// @dev Context of the call should be made to the hyperlane mailbox.
    function dispatch(
        uint32 destinationDomain_,
        bytes32 recipientAddress_,
        bytes calldata messageBody_
    ) external returns (uint256);
}
