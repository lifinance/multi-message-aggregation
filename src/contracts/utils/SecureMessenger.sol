// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import {IEIP6170} from "../interfaces/IEIP6170.sol";

/// @dev contract is designed to support more secure cross-chain messaging
contract SecureMessenger is IEIP6170 {
    uint256 public quorum;

    address[] public bridges;
    address public controller;

    mapping(bytes => bytes) public receivedMessage;
    mapping(bytes => uint256) public receivedMessageQuorum;

    constructor(address controller_) {
        controller = controller_;
    }

    /// @dev allows controller to configure the allowed bridge implementations
    /// @notice bridge implementation should follow EIP-6170
    function setBridgeImplementation(address[] memory bridges_) external {
        require(msg.sender == controller);

        for (uint256 i = 0; i < bridges_.length; i++) {
            require(bridges_[i] != address(0));
        }

        bridges = bridges_;
    }

    /// @dev allows controller to set quorum for receive message
    /// @notice quorum should be equal to the number of bridges configured for message
    /// deliverability
    function setQuorum(uint256 quorum_) external {
        require(msg.sender == controller);

        quorum = quorum_;
    }

    /// @dev always confronts to the EIP-6170 interface at any level
    function sendMessage(
        bytes memory chainId_,
        bytes memory receiver_,
        bytes memory message_,
        bytes memory data_
    ) external payable override returns (bool) {}

    /// @dev always receives this call from implementation contracts
    function receiveMessage(
        bytes memory chainId_,
        bytes memory sender_,
        bytes memory message_,
        bytes memory data_
    ) external override returns (bool) {}
}
