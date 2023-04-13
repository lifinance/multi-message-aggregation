// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Errors} from "../utils/Errors.sol";

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {IAxelarGasService} from "../interface/IAxelarGasService.sol";
import {IAxelarGateway} from "../interface/IAxelarGateway.sol";

abstract contract SenderImpl is IEIP6170, Getter, Errors {
    /// @dev see IEIP6170-{sendMessage}
    function sendMessage(
        bytes memory chainId_,
        bytes memory receiver_,
        bytes memory message_,
        bytes memory data_
    ) external payable override returns (bool) {
        string memory ambChainId = getChainId(chainId_);

        /// @notice can be used as a mechanism to prevent messaging to chains if app
        /// turns to remove them post deployment
        if (bytes(ambChainId).length == 0) {
            revert INVALID_RECEIVER_CHAIN();
        }

        /// @notice: no purpose to override gas in axelar atm
        /// note: using data to silence unused variable warning
        /// data_ will be for AMBs with custom overrides
        data_;
        IAxelarGateway(getGateway()).callContract(
            ambChainId,
            string(receiver_),
            message_
        );

        IAxelarGasService(getGasService()).payNativeGasForContractCall{
            value: msg.value
        }(address(this), ambChainId, string(receiver_), message_, msg.sender);
        emit MessageSent(receiver_, chainId_, message_, data_);

        /// note: redundant return value; using this for now
        return true;
    }
}
