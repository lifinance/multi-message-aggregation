pragma solidity ^0.8.19;

enum MessageStatus {
    NOT_EXECUTED,
    EXECUTION_FAILED,
    EXECUTION_SUCCEEDED
}

struct Message {
    uint8 version;
    uint64 nonce;
    uint32 sourceChainId;
    address sourceAddress;
    uint32 destinationChainId;
    bytes32 destinationAddress;
    bytes data;
}

interface ITelepathyRouter {
    event SentMessage(
        uint64 indexed nonce,
        bytes32 indexed msgHash,
        bytes message
    );

    function send(
        uint32 destinationChainId,
        address destinationAddress,
        bytes calldata data
    ) external returns (bytes32);

    function send(
        uint32 destinationChainId,
        bytes32 destinationAddress,
        bytes calldata data
    ) external returns (bytes32);

    function sendViaStorage(
        uint32 destinationChainId,
        bytes32 destinationAddress,
        bytes calldata data
    ) external returns (bytes32);

    function sendViaStorage(
        uint32 destinationChainId,
        address destinationAddress,
        bytes calldata data
    ) external returns (bytes32);
}
