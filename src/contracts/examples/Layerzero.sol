/// SPDX-License-Identifier: Apache 3.0
pragma solidity ^0.8.19;

import {LayerZero} from "../layerzero/LayerZero.sol";
import {ReceiverImpl} from "../layerzero/abstracts/ReceiverImpl.sol";
import {IEIP6170} from "../interfaces/IEIP6170.sol";

contract LayerZeroExample is LayerZero {
    uint256 public received;

    constructor(address _endpoint) LayerZero(_endpoint) {}

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
