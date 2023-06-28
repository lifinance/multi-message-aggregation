// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Getter} from "../state/Getter.sol";
import {IMailbox} from "../interface/IMailbox.sol";
import {IEIP6170} from "../../../interfaces/IEIP6170.sol";

/// @title SenderImpl
/// @dev sends a message from onechain to another using Hyperlane
abstract contract SenderImpl is IEIP6170, Getter {
    /// @inheritdoc IEIP6170
    function sendMessage(
        bytes memory _chainId,
        bytes memory,
        bytes memory _message,
        bytes memory
    ) external payable override returns (bool) {
        uint32 hyperlaneChainId = getChainId(_chainId);

        /// @notice: no purpose to override gas in hyperlane
        /// note: using data to silence unused variable warning
        /// data_ will be for AMBs with custom overrides
        IMailbox(getMailbox()).dispatch(
            hyperlaneChainId,
            getTrustedRemote(hyperlaneChainId),
            _message
        );

        emit MessageSent(
            abi.encode(getTrustedRemote(hyperlaneChainId)),
            _chainId,
            _message,
            ""
        );

        /// note: redundant return value; using this for now
        return true;
    }
}
