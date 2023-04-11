// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../interfaces/IEIP6170.sol";
import {IMailbox} from "../interface/IMailbox.sol";
import {Errors} from "../utils/Errors.sol";
abstract contract SenderImpl is IEIP6170, Getter, Errors {
    /// @dev see IEIP6170-{sendMessage}
    function sendMessage(
        bytes memory chainId_,
        bytes memory receiver_,
        bytes memory message_,
        bytes memory data_
    ) external payable override returns (bool) {
        uint32 ambChainId = getChainId(chainId_);

        /// @notice can be used as a mechanism to prevent messaging to chains if app 
        /// turns to remove them post deployment
        if(ambChainId == 0) {
            revert INVALID_RECEIVER_CHAIN();
        }
        
        /// @notice: no purpose to override gas in hyperlane
        /// note: using data to silence unused variable warning
        /// data_ will be for AMBs with custom overrides
        data_;
        IMailbox(getMailbox()).dispatch(
            ambChainId,
            bytes32(receiver_),
            message_
        );
        emit MessageSent(receiver_, chainId_, message_, data_);

        /// note: redundant return value; using this for now
        return true;
    }
}
