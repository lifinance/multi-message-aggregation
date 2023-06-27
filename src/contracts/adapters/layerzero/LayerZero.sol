/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";
import {Error} from "../../libraries/Error.sol";

/// @title LayerZero
/// @dev adapter contract for exposing LayerZero AMB in a wrapped EIP6170 Interface
contract LayerZero is Setter, SenderImpl, ReceiverImpl {
    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _endpoint) {
        setController(msg.sender);

        setEndpoint(_endpoint);

        /// @dev can whitelist all their allowed chains
        setChainId(uint16(101), abi.encode("ETHEREUM"));
        setChainId(uint16(109), abi.encode("POLYGON"));
    }

    /*///////////////////////////////////////////////////////////////
                            PREVILAGED FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function changeController(address _newController) external virtual {
        setController(_newController);
    }
}
