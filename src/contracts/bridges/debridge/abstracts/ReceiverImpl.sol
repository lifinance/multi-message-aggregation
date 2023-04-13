// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";

import {IDeBridgeGate} from "../interface/IDeBridgeGate.sol";
import {IDeBridgeReceiver} from "../interface/IDeBridgeReceiver.sol";
import {ICallProxy} from "../interface/ICallProxy.sol";

/// @notice will handle all the message delivery from de bridge's router bus
abstract contract ReceiverImpl is IEIP6170, IDeBridgeReceiver, Getter {
    /// @dev see IDeBridgeReceiver-{executeMessage}
    function executeMessage(
        address multiMessageSender_,
        address multiMessageReceiver_,
        bytes calldata data_,
        bytes32 msgId_
    ) external {
        ICallProxy callProxy = ICallProxy(IDeBridgeGate(getGate()).callProxy());
        require(msg.sender == address(callProxy));

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = data_;
        bytes memory sender = abi.encode(multiMessageSender_);
        bytes memory chainId = getEIPChainId(callProxy.submissionChainIdFrom());

        receiveMessage(chainId, sender, message, bytes(""));
    }

    /// @dev see IEIP6170-{receiveMessage}
    /// note: override this function to receive message
    /// note: emit MessageReceived event on successful message delivery
    function receiveMessage(
        bytes memory chainId_,
        bytes memory sender_,
        bytes memory message_,
        bytes memory data_
    ) public virtual override returns (bool) {
        /// FIXME: add required validations here
        ICallProxy callProxy = ICallProxy(IDeBridgeGate(getGate()).callProxy());
        require(msg.sender == address(callProxy));
    }
}
