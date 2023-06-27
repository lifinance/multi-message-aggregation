// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IDeBridgeReceiver {
    function executeMessage(
        address multiMessageSender,
        address multiMessageReceiver,
        bytes calldata data,
        bytes32 msgId
    ) external;
}
