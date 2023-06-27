/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

contract Celer is Setter, SenderImpl, ReceiverImpl {
    constructor(address _messageBus) {
        setController(msg.sender);
        setMessageBus(_messageBus);

        /// @dev can whitelist all their allowed chains
        setChainId(uint32(1), abi.encode("ETHEREUM"));
        setChainId(uint32(137), abi.encode("POLYGON"));
    }

    function changeController(address _newController) external virtual {
        setController(_newController);
    }
}
