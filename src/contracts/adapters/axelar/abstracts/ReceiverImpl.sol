// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {IAxelarExecutable} from "../interface/IAxelarExecutable.sol";
import {IAxelarGateway} from "../interface/IAxelarGateway.sol";

/// @notice will handle all the message delivery from axelar's gateway
abstract contract ReceiverImpl is IEIP6170, IAxelarExecutable, Getter {
    /// @dev see IAxelarExecutable-{execute}
    function execute(
        bytes32 _commandId,
        string calldata _sourceChain,
        string calldata _sourceAddress,
        bytes calldata _payload
    ) external override {
        require(msg.sender == getGateway());

        /// note: implement sender authentication.
        /// note: casting calldata to memory
        bytes memory message = _payload;
        bytes memory sender = abi.encode(_sourceAddress);
        bytes memory chainId = getEIPChainId(_sourceChain);

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
        require(msg.sender == getGateway());
    }

    function gateway() external view override returns (IAxelarGateway) {
        return IAxelarGateway(getGateway());
    }
}
