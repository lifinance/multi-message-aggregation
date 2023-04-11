/// SPDX-License-Identifier: Apache 3.0
pragma solidity ^0.8.19;

import "forge-std/console.sol";
import {Hyperlane} from "../hyperlane/Hyperlane.sol";
import {ReceiverImpl} from "../hyperlane/abstracts/ReceiverImpl.sol";
import {IEIP6170} from "../interfaces/IEIP6170.sol";

contract HyperlaneExample is Hyperlane {
    uint256 public received;

    constructor(address _mailbox) Hyperlane(_mailbox) {}

    function receiveMessage(
        bytes memory chainId_,
        bytes memory sender_,
        bytes memory message_,
        bytes memory data_
    ) public override(IEIP6170, ReceiverImpl) returns (bool) {
        super.receiveMessage(chainId_, sender_, message_, data_);

        received = abi.decode(message_, (uint256));
    }
}
