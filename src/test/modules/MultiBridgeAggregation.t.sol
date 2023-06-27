// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import {Setup} from "../Setup.t.sol";
import {LIFIAggregator} from "../../contracts/Aggregator.sol";

contract MultiBridgeAggregationTest is Setup {
    function setUp() public override {
        super.setUp();
    }

    function test_message_delivery() public {
        vm.selectFork(SRC_FORK_ID);

        /// @dev LIFI Aggregator Set Config
        LIFIAggregator(contractAddress[SRC_FORK_ID][abi.encode("AGGREGATOR")])
            .setConfig(1, 1);

        uint256[] memory bridges = new uint256[](1);
        bridges[0] = 1;

        /// @dev LIFI Aggregator Set Module Config
        LIFIAggregator(contractAddress[SRC_FORK_ID][abi.encode("AGGREGATOR")])
            .setModuleConfig(1, 2, abi.encode(bridges));

        LIFIAggregator(contractAddress[SRC_FORK_ID][abi.encode("AGGREGATOR")])
            .xSend(abi.encode("POLYGON"), abi.encode("1"), abi.encode(""));
    }
}
