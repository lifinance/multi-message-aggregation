pragma solidity ^0.8.19;

interface IReceiver {
    function xReceive(bytes memory _srcChainId, bytes memory _message) external;
}
