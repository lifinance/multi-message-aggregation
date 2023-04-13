/// SPDX-License-Identifier: Apache 3.0
pragma solidity ^0.8.19;

import {Hyperlane} from "../bridges/hyperlane/Hyperlane.sol";
import {ReceiverImpl} from "../bridges/hyperlane/abstracts/ReceiverImpl.sol";
import {IEIP6170} from "../interfaces/IEIP6170.sol";

contract HyperlaneExample is Hyperlane {
    uint256 public received;
    address public finalDst;

    constructor(address mailbox_, address finalDst_) Hyperlane(mailbox_) {
        finalDst = finalDst_;
    }

    function receiveMessage(
        bytes memory chainId_,
        bytes memory sender_,
        bytes memory message_,
        bytes memory data_
    ) public override(IEIP6170, ReceiverImpl) returns (bool) {
        super.receiveMessage(chainId_, sender_, message_, data_);

        if (finalDst != address(0)) {
            IEIP6170(finalDst).receiveMessage(
                chainId_,
                sender_,
                message_,
                data_
            );
        } else {
            received = abi.decode(message_, (uint256));
        }
    }
}
