/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {IGAC} from "../../interfaces/IGAC.sol";
import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";

/// @title Axelar
/// @dev adapter contract for exposing Axelar AMB in a wrapped EIP6170 Interface
contract Axelar is Setter, SenderImpl, ReceiverImpl {
    /*///////////////////////////////////////////////////////////////
                            MODIFIER
    //////////////////////////////////////////////////////////////*/

    // modifier onlyGAC() {
    //     if (!IGAC(getGac()).isCallerOwner(msg.sender)) {
    //         revert Error.INVALID_PREVILAGED_CALLER();
    //     }
    //     _;
    // }

    constructor(address _gateway) {
        setGateway(_gateway);

        /// @dev can whitelist all their allowed chains
        setChainId("ethereum", abi.encode("ETHEREUM"));
        setChainId("polygon", abi.encode("POLYGON"));
    }
}
