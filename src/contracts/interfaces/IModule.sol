pragma solidity ^0.8.19;

interface IModule {
    function setConfig(
        uint8 _configType,
        bytes memory _config,
        address _user
    ) external;

    function sendMessage(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData,
        address _user
    ) external;

    function receiveMessage(
        bytes memory _sender,
        bytes memory _receiver,
        bytes memory _srcChainId,
        bytes memory _message
    ) external;
}
