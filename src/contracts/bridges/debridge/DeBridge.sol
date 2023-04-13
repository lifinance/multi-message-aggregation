/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

contract DeBridge is Setter, SenderImpl, ReceiverImpl {
    constructor(address messageBus_) {
        setController(msg.sender);
        setMessageBus(messageBus_);

        /// @dev can whitelist all their allowed chains
        setChainId(1, abi.encode("ETHEREUM"));
        setChainId(137, abi.encode("POLYGON"));
    }

    function changeController(address newController_) external virtual {
        setController(newController_);
    }
}
