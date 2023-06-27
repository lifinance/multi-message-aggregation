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
        address _multiMessageSender,
        address _multiMessageReceiver,
        bytes calldata _data,
        bytes32 _msgId
    ) external {
        ICallProxy callProxy = ICallProxy(IDeBridgeGate(getGate()).callProxy());
        require(msg.sender == address(callProxy));

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = _data;
        bytes memory sender = abi.encode(_multiMessageSender);
        bytes memory chainId = getLIFIChainId(
            callProxy.submissionChainIdFrom()
        );

        receiveMessage(chainId, sender, message, bytes(""));
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
        /// FIXME: add required validations here
        ICallProxy callProxy = ICallProxy(IDeBridgeGate(getGate()).callProxy());
        require(msg.sender == address(callProxy));
    }
}
