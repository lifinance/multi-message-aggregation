// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

/// @dev interface for receiving messages using hyperlane.
interface IMessageRecipient {
    function handle(
        uint32 origin_,
        bytes32 sender_,
        bytes calldata messageBody_
    ) external;
}
