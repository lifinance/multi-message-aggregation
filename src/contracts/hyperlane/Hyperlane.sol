/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

contract Hyperlane is Setter, SenderImpl, ReceiverImpl {
    constructor() {
        setController(msg.sender);

        /// @dev can whitelist all their allowed chains
        setChainId(uint32(1), abi.encode("ETHEREUM"));
    }

    function changeController(address newController_) external virtual {
        setController(newController_);
    }
}
