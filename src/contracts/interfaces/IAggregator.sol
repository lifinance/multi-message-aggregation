pragma solidity ^0.8.19;

interface IAggregator {
    function xSend(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData
    ) external payable;

    function xReceive(
        bytes memory _srcChainId,
        address _receiver,
        bytes memory _message
    ) external;
}
