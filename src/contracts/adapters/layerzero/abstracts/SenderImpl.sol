// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {ILayerZeroEndpoint} from "../interface/ILayerZeroEndpoint.sol";

abstract contract SenderImpl is IEIP6170, Getter {
    /// @dev see IEIP6170-{sendMessage}
    function sendMessage(
        bytes memory _chainId,
        bytes memory _receiver,
        bytes memory _message,
        bytes memory _data
    ) external payable override returns (bool) {
        ILayerZeroEndpoint(getEndpoint()).send(
            getChainId(_chainId),
            _receiver,
            _message,
            payable(msg.sender), /// @dev refund address if set to the msg sender
            address(0), /// @dev should expand to use zro tokens
            _data
        );
        emit MessageSent(_receiver, _chainId, _message, _data);

        /// note: redundant return value; using this for now
        return true;
    }
}
