/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

contract Axelar is Setter, SenderImpl, ReceiverImpl {
    constructor(address gateway_) {
        setController(msg.sender);
        setGateway(gateway_);

        /// @dev can whitelist all their allowed chains
        setChainId("ethereum", abi.encode("ETHEREUM"));
        setChainId("polygon", abi.encode("POLYGON"));
    }

    function changeController(address newController_) external virtual {
        setController(newController_);
    }
}
