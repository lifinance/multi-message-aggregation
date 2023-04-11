// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../interfaces/IEIP6170.sol";
import {ILayerZeroReceiver} from "../interface/ILayerZeroReceiver.sol";

/// @notice will handle all the message delivery from layerzero's endpoint
/// TODO: Improved validations in lzReceive, nonce-based replay protection
abstract contract ReceiverImpl is IEIP6170, ILayerZeroReceiver, Getter {
    /// @dev see ILayerZeroReceiver-{lzReceive}
    function lzReceive(
        uint16 srcChainId_,
        bytes calldata srcAddress_,
        uint64 nonce_,
        bytes calldata payload_
    ) external override {
        require(msg.sender == getEndpoint());

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = payload_;
        bytes memory sender = srcAddress_;
        bytes memory chainId = getEIPChainId(srcChainId_);

        receiveMessage(chainId, sender, message, abi.encodePacked(nonce_));
    }

    /// @dev see IEIP6170-{receiveMessage}
    /// note: override this function to receive message
    /// note: emit MessageReceived event on successful message delivery
    function receiveMessage(
        bytes memory chainId_,
        bytes memory sender_,
        bytes memory message_,
        bytes memory data_
    ) public override returns (bool) {
        /// note: this is a wrapper & hence the caller should be the address itself
        /// @dev function is public to adhere to the EIP
        require(msg.sender == address(this));

        /// @dev can override to do whatever they wish to with the message
        /// @dev can call the pre-determined address with the received data
    }
}
