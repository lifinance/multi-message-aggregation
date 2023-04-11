// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../interfaces/IEIP6170.sol";
import {ILayerZeroEndpoint} from "../interface/ILayerZeroEndpoint.sol";

abstract contract SenderImpl is IEIP6170, Getter {
    /// @dev see IEIP6170-{sendMessage}
    function sendMessage(
        bytes memory chainId_,
        bytes memory receiver_,
        bytes memory message_,
        bytes memory data_
    ) external payable override returns (bool) {
        ILayerZeroEndpoint(getEndpoint()).send(
            getChainId(chainId_),
            receiver_,
            message_,
            payable(msg.sender),     /// @dev refund address if set to the msg sender
            address(0),     /// @dev should expand to use zro tokens
            data_
        );
        emit MessageSent(receiver_, chainId_, message_, data_);

        /// note: redundant return value; using this for now
        return true;
    }
}
