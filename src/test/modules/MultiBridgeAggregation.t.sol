// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import {Vm} from "forge-std/Test.sol";

/// @dev imports from Pigeon Helper (Facilitate State Transfer Mocks)
import {LayerZeroHelper} from "pigeon/layerzero/LayerZeroHelper.sol";
import {HyperlaneHelper} from "pigeon/hyperlane/HyperlaneHelper.sol";

import {Setup} from "../Setup.t.sol";
import {MockApp} from "../mock/MockApp.sol";
import {LIFIAggregator} from "../../contracts/Aggregator.sol";

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
            abi.encode("test_test"),
            ""
        );

        Vm.Log[] memory logs = vm.getRecordedLogs();

        LayerZeroHelper(bridgeHelper[SRC_FORK_ID][1]).help(
            LAYERZERO_POLYGON_ENDPOINT,
            500000,
            DST_FORK_ID,
            logs
        );

        HyperlaneHelper(bridgeHelper[SRC_FORK_ID][2]).help(
            HYPERLANE_MAILBOX,
            HYPERLANE_MAILBOX,
            DST_FORK_ID,
            logs
        );
        vm.selectFork(DST_FORK_ID);

        /// @dev asserting message delivery
        assertEq(
            MockApp(mockApp[DST_FORK_ID]).message(),
            abi.encode("test_test")
        );
    }

    function _setConfigSrcChainAndDstChain() internal {
        vm.selectFork(SRC_FORK_ID);

        uint256[] memory bridges = new uint256[](2);
        bridges[0] = 1;
        bridges[1] = 2;

        MockApp(mockApp[SRC_FORK_ID]).setConfig();
        MockApp(mockApp[SRC_FORK_ID]).setModuleConfig(1, abi.encode(2)); // quorum = 2
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
        MockApp(mockApp[DST_FORK_ID]).setModuleConfig(1, abi.encode(2)); // quorum = 2
        MockApp(mockApp[DST_FORK_ID]).setModuleConfig(2, abi.encode(bridges));
        MockApp(mockApp[DST_FORK_ID]).setModuleConfig(
            3,
            abi.encode(
                /// sender + receiver
                abi.encodePacked(mockApp[SRC_FORK_ID], mockApp[DST_FORK_ID]),
                abi.encode("ETHEREUM")
            )
        );
    }
}
