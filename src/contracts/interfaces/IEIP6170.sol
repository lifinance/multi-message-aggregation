// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

/// @title Cross-Chain Messaging interface
/// @dev Allows seamless interchain messaging.
/// @author Sujith Somraaj
/// Note: Bytes are used throughout the implementation to support non-evm chains.

interface IEIP6170 {
    /// @dev This emits when a cross-chain message is sent.
    /// Note: MessageSent MUST trigger when a message is sent, including zero bytes transfers.
    event MessageSent(
        bytes to,
        bytes toChainId,
        bytes message,
        bytes extraData
    );

    /// @dev This emits when a cross-chain message is received.
    /// MessageReceived MUST trigger on any successful call to receiveMessage(bytes chainId, bytes sender, bytes message) function.
    event MessageReceived(bytes from, bytes fromChainId, bytes message);

    /// @dev Sends a message to a receiving address on a different blockchain.
    /// @param _chainId is the unique identifier of receiving blockchain.
    /// @param _receiver is the address of the receiver.
    /// @param _message is the arbitrary message to be delivered.
    /// @param _data is a bridge-specific encoded data for off-chain relayer infrastructure.
    /// @return the status of the process on the sending chain.
    /// Note: this function is designed to support both evm and non-evm chains
    /// Note: proposing chain-ids be the bytes encoding their native token name string. For eg., abi.encode("ETH"), abi.encode("SOL") imagining they cannot override.
    function sendMessage(
        bytes memory _chainId,
        bytes memory _receiver,
        bytes memory _message,
        bytes memory _data
    ) external payable returns (bool);

    /// @dev Receives a message from a sender on a different blockchain.
    /// @param _chainId is the unique identifier of the sending blockchain.
    /// @param _sender is the address of the sender.
    /// @param _message is the arbitrary message sent by the sender.
    /// @return the status of message processing/storage.
    /// Note: sender validation (or) message validation should happen before processing the message.
    function receiveMessage(
        bytes memory _chainId,
        bytes memory _sender,
        bytes memory _message,
        bytes memory _data
    ) external returns (bool);
}
