/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

contract LayerZero is Setter, SenderImpl, ReceiverImpl {
    constructor(address endpoint_) {
        setController(msg.sender);

        setEndpoint(endpoint_);

        /// @dev can whitelist all their allowed chains
        setChainId(uint16(101), abi.encode("ETHEREUM"));
        setChainId(uint16(109), abi.encode("POLYGON"));
    }

    function changeController(address newController_) external virtual {
        setController(newController_);
    }
}
