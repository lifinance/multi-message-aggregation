// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Errors} from "../utils/Errors.sol";

import {Getter} from "../state/Getter.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";
import {ITelepathyRouter} from "../interface/ITelepathyRouter.sol";

abstract contract SenderImpl is IEIP6170, Getter, Errors {
    /// @dev see IEIP6170-{sendMessage}
    function sendMessage(
        bytes memory _chainId,
        bytes memory _receiver,
        bytes memory _message,
        bytes memory _data
    ) external payable override returns (bool) {
        uint32 ambChainId = getChainId(_chainId);

        /// @notice can be used as a mechanism to prevent messaging to chains if app
        /// turns to remove them post deployment
        if (ambChainId == 0) {
            revert INVALID_RECEIVER_CHAIN();
        }

        /// @notice: no purpose to override gas in axelar atm
        /// note: using data to silence unused variable warning
        /// data_ will be for AMBs with custom overrides
        _data;
        ITelepathyRouter(getRouter()).send(
            ambChainId,
            abi.decode(_receiver, (address)),
            _message
        );

        /// note: redundant return value; using this for now
        return true;
    }
}
