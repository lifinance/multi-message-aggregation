// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {ILayerZeroReceiver} from "../interface/ILayerZeroReceiver.sol";

/// @notice will handle all the message delivery from layerzero's endpoint
/// TODO: Improved validations in lzReceive, nonce-based replay protection
abstract contract ReceiverImpl is IEIP6170, ILayerZeroReceiver, Getter {
    /// @dev see ILayerZeroReceiver-{lzReceive}
    function lzReceive(
        uint16 _srcChainId,
        bytes calldata _srcAddress,
        uint64 _nonce,
        bytes calldata _payload
    ) external override {
        require(msg.sender == getEndpoint());

        /// note: implement sender authentication.
        /// note: casting calldata to memory

        /// note: src address will be wrapper on the other chain
        bytes memory message = _payload;
        bytes memory sender = _srcAddress;
        bytes memory chainId = getEIPChainId(_srcChainId);

        receiveMessage(chainId, sender, message, abi.encodePacked(_nonce));
    }

    /// @dev see IEIP6170-{receiveMessage}
    /// note: override this function to receive message
    /// note: emit MessageReceived event on successful message delivery
    function receiveMessage(
        bytes memory _chainId,
        bytes memory _sender,
        bytes memory _message,
        bytes memory _data
    ) public virtual override returns (bool) {
        /// @dev function is public to adhere to the EIP
        require(msg.sender == getEndpoint());

        /// @dev can override to do whatever they wish to with the message
        /// @dev can call the pre-determined address with the received data
    }
}
