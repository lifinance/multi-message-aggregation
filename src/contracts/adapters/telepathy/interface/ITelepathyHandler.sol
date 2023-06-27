pragma solidity ^0.8.19;

interface ITelepathyHandler {
    function handleTelepathy(
        uint32 _sourceChainId,
        address _sourceAddress,
        bytes memory _data
    ) external returns (bytes4);
}
