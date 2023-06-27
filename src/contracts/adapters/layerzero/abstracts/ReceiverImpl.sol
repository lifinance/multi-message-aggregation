// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {ILayerZeroReceiver} from "../interface/ILayerZeroReceiver.sol";
import {Error} from "../../../libraries/Error.sol";
import {IModule} from "../../../interfaces/IModule.sol";

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
        /// @dev caller authentication
        if (msg.sender != getEndpoint()) {
            revert Error.NOT_LAYERZERO_ENDPOINT();
        }

        bytes memory _srcAddressMemory = _srcAddress;

        /// @dev sender authentication.
        if (
            keccak256(getTrustedRemote(_srcChainId)) !=
            keccak256(_srcAddressMemory)
        ) {
            revert Error.INVALID_SOURCE_SENDER();
        }

        /// @dev nonce validation.
        if (getNonceStatus(_nonce)) {
            revert Error.USED_UNIQUE_ID();
        }

        bytes memory message = _payload;
        bytes memory sender = _srcAddress;
        bytes memory chainId = getEIPChainId(_srcChainId);

        receiveMessage(chainId, sender, message, "");
    }

    /// @dev see IEIP6170-{receiveMessage}
    /// note: override this function to receive message
    /// note: emit MessageReceived event on successful message delivery
    function receiveMessage(
        bytes memory _chainId,
        bytes memory,
        bytes memory _message,
        bytes memory
    ) public virtual override returns (bool) {
        /// @dev added for more validation
        if (msg.sender != getEndpoint()) {
            revert Error.NOT_LAYERZERO_ENDPOINT();
        }

        /// @dev calls module after all validations
        // IModule().receiveMessage(_chainId, _message);

        /// @dev if code reaches here then it is success
        return true;
    }
}
