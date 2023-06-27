// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

/// @dev imported from LayerZero
/// MORE_INFO: https://layerzero.gitbook.io/docs/evm-guides/interfaces/evm-solidity-interfaces/ilayerzeroreceiver
interface ILayerZeroReceiver {
    // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
    // @param _srcChainId - the source endpoint identifier
    // @param _srcAddress - the source sending contract address from the source chain
    // @param _nonce - the ordered message nonce
    // @param _payload - the signed payload is the UA bytes has encoded to be sent
    function lzReceive(
        uint16 srcChainId_,
        bytes calldata srcAddress_,
        uint64 nonce_,
        bytes calldata payload_
    ) external;
}
