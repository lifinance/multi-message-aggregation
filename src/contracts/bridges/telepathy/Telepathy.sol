/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

contract Telepathy is Setter, SenderImpl, ReceiverImpl {
    constructor(address router_) {
        setController(msg.sender);
        setRouter(router_);

        /// @dev can whitelist all their allowed chains
        setChainId(1, abi.encode("ETHEREUM"));
        setChainId(137, abi.encode("POLYGON"));
    }

    function changeController(address newController_) external virtual {
        setController(newController_);
    }
}
