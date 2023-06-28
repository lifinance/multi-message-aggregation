// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import {LayerZeroHelper} from "pigeon/layerzero/LayerZeroHelper.sol";

import {Setup} from "../Setup.t.sol";
import {MockApp} from "../mock/MockApp.sol";
import {LIFIAggregator} from "../../contracts/Aggregator.sol";

import "forge-std/console.sol";

contract MultiBridgeAggregationTest is Setup {
    mapping(uint256 forkId => address mockApp) public mockApp;

    function setUp() public override {
        super.setUp();

        vm.selectFork(SRC_FORK_ID);
        mockApp[SRC_FORK_ID] = address(
            new MockApp(contractAddress[SRC_FORK_ID][abi.encode("AGGREGATOR")])
        );

        vm.selectFork(DST_FORK_ID);
        mockApp[DST_FORK_ID] = address(
            new MockApp(contractAddress[DST_FORK_ID][abi.encode("AGGREGATOR")])
        );
    }

    function test_message_delivery() public {
        _setConfigSrcChainAndDstChain();

        vm.selectFork(SRC_FORK_ID);

        vm.recordLogs();

        MockApp(mockApp[SRC_FORK_ID]).xSend{value: 1 ether}(
            abi.encode("POLYGON"),
            abi.encode("1"),
            ""
        );

        LayerZeroHelper(bridgeHelper[SRC_FORK_ID][1]).help(
            LAYERZERO_POLYGON_ENDPOINT,
            500000,
            DST_FORK_ID,
            vm.getRecordedLogs()
        );

        vm.selectFork(DST_FORK_ID);

        /// @dev asserting message delivery
        assertEq(MockApp(mockApp[DST_FORK_ID]).message(), abi.encode("1"));
    }

    function _setConfigSrcChainAndDstChain() internal {
        vm.selectFork(SRC_FORK_ID);

        uint256[] memory bridges = new uint256[](1);
        bridges[0] = 1;

        MockApp(mockApp[SRC_FORK_ID]).setConfig();
        MockApp(mockApp[SRC_FORK_ID]).setModuleConfig(2, abi.encode(bridges));
        MockApp(mockApp[SRC_FORK_ID]).setModuleConfig(
            3,
            abi.encode(
                abi.encodePacked(mockApp[DST_FORK_ID], mockApp[SRC_FORK_ID]), /// dst address + src address
                abi.encode("POLYGON")
            )
        );

        vm.selectFork(DST_FORK_ID);

        MockApp(mockApp[DST_FORK_ID]).setConfig();
        MockApp(mockApp[DST_FORK_ID]).setModuleConfig(2, abi.encode(bridges));
        MockApp(mockApp[DST_FORK_ID]).setModuleConfig(
            3,
            abi.encode(
                abi.encodePacked(mockApp[SRC_FORK_ID], mockApp[DST_FORK_ID]),
                abi.encode("ETHEREUM")
            )
        );
    }
}
