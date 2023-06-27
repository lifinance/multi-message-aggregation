/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

contract Axelar is Setter, SenderImpl, ReceiverImpl {
    constructor(address _gateway) {
        setController(msg.sender);
        setGateway(_gateway);

        /// @dev can whitelist all their allowed chains
        setChainId("ethereum", abi.encode("ETHEREUM"));
        setChainId("polygon", abi.encode("POLYGON"));
    }

    function changeController(address _newController) external virtual {
        setController(_newController);
    }
}
