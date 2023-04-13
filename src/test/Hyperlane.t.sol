/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {HyperlaneHelper} from "pigeon/hyperlane/HyperlaneHelper.sol";
import {HyperlaneExample} from "src/contracts/examples/Hyperlane.sol";

interface IMailbox {
    event Dispatch(
        address indexed sender,
        uint32 indexed destination,
        bytes32 indexed recipient,
        bytes message
    );

    function dispatch(
        uint32 _destinationDomain,
        bytes32 _recipientAddress,
        bytes calldata _messageBody
    ) external returns (bytes32);
}

interface IInterchainGasPaymaster {
    function payForGas(
        bytes32 _messageId,
        uint32 _destinationDomain,
        uint256 _gasAmount,
        address _refundAddress
    ) external payable;
}

contract HyperlaneTest is Test {
    HyperlaneHelper helper;
    HyperlaneExample src;
    HyperlaneExample target;

    uint256 SRC_FORK_ID;
    uint256 DST_FORK_ID;

    uint256 constant ETH_TO_POLYGON_MESSAGE = 1;

    uint32 constant SRC_DOMAIN = 1;
    uint32 constant DST_DOMAIN = 137;

    address constant MAILBOX = 0x35231d4c2D8B8ADcB5617A638A0c4548684c7C70;
    address constant IGP = 0xdE86327fBFD04C4eA11dC0F270DA6083534c2582;

    string public SRC_CHAIN_RPC = vm.envString("ETHEREUM_RPC_URL");
    string public DST_CHAIN_RPC = vm.envString("POLYGON_RPC_URL");

    function setUp() external {
        SRC_FORK_ID = vm.createSelectFork(SRC_CHAIN_RPC, 16400467);
        src = new HyperlaneExample(MAILBOX, address(0));
        helper = new HyperlaneHelper();

        DST_FORK_ID = vm.createSelectFork(DST_CHAIN_RPC, 38063686);
        target = new HyperlaneExample(MAILBOX, address(0));
    }

    function testCrossChainMessaging() external {
        vm.selectFork(SRC_FORK_ID);

        vm.recordLogs();
        _sendMessageToPolygon();

        Vm.Log[] memory logs = vm.getRecordedLogs();

        helper.help(MAILBOX, MAILBOX, DST_FORK_ID, logs);

        vm.selectFork(DST_FORK_ID);
        assertEq(target.received(), ETH_TO_POLYGON_MESSAGE);
    }

    function _sendMessageToPolygon() internal {
        IMailbox mailbox = IMailbox(MAILBOX);
        bytes32 id = mailbox.dispatch(
            DST_DOMAIN,
            addressToBytes32(address(target)),
            abi.encode(ETH_TO_POLYGON_MESSAGE)
        );

        IInterchainGasPaymaster(IGP).payForGas(
            id,
            DST_DOMAIN,
            100000,
            msg.sender
        );
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
