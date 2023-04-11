/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {LayerZeroHelper} from "pigeon/layerzero/LayerZeroHelper.sol";
import {HyperlaneHelper} from "pigeon/hyperlane/HyperlaneHelper.sol";

import {LayerZeroExample} from "src/contracts/examples/Layerzero.sol";
import {HyperlaneExample} from "src/contracts/examples/Hyperlane.sol";

import {SecureMessenger} from "src/contracts/utils/SecureMessenger.sol";

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

interface ILayerZeroEndpoint {
    function send(
        uint16 _dstChainId,
        bytes calldata _destination,
        bytes calldata _payload,
        address payable _refundAddress,
        address _zroPaymentAddress,
        bytes calldata _adapterParams
    ) external payable;
}

contract SecureMessengerTest is Test {
    LayerZeroHelper helper_lz;
    HyperlaneHelper helper_hyperlane;

    LayerZeroExample src_lz;
    LayerZeroExample target_lz;

    HyperlaneExample src_hyperlane;
    HyperlaneExample target_hyperlane;

    SecureMessenger messenger_eth;
    SecureMessenger messenger_polygon;

    uint256 SRC_FORK_ID;
    uint256 DST_FORK_ID;

    uint256 constant ETH_TO_POLYGON_MESSAGE = 1;

    uint16 constant SRC_ID = 101;
    uint16 constant DST_ID = 109;

    uint32 constant SRC_DOMAIN = 1;
    uint32 constant DST_DOMAIN = 137;

    address constant SRC_ENDPOINT = 0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675;
    address constant DST_ENDPOINT = 0x3c2269811836af69497E5F486A85D7316753cf62;

    address constant MAILBOX = 0x35231d4c2D8B8ADcB5617A638A0c4548684c7C70;
    address constant IGP = 0xdE86327fBFD04C4eA11dC0F270DA6083534c2582;

    string public SRC_CHAIN_RPC = vm.envString("ETHEREUM_RPC_URL");
    string public DST_CHAIN_RPC = vm.envString("POLYGON_RPC_URL");

    function setUp() external {
        SRC_FORK_ID = vm.createSelectFork(SRC_CHAIN_RPC, 16400467);
        messenger_eth = new SecureMessenger();

        src_lz = new LayerZeroExample(SRC_ENDPOINT, address(messenger_eth));
        helper_lz = new LayerZeroHelper();

        src_hyperlane = new HyperlaneExample(MAILBOX, address(messenger_eth));
        helper_hyperlane = new HyperlaneHelper();

        address[] memory bridges_eth = new address[](2);
        bridges_eth[0] = address(src_lz);
        bridges_eth[1] = address(src_hyperlane);
        messenger_eth.setBridgeImplementation(bridges_eth);

        DST_FORK_ID = vm.createSelectFork(DST_CHAIN_RPC, 38063686);
        messenger_polygon = new SecureMessenger();
        target_lz = new LayerZeroExample(
            DST_ENDPOINT,
            address(messenger_polygon)
        );
        target_hyperlane = new HyperlaneExample(
            MAILBOX,
            address(messenger_polygon)
        );

        address[] memory bridges_polygon = new address[](2);
        bridges_polygon[0] = address(target_lz);
        bridges_polygon[1] = address(target_hyperlane);
        messenger_polygon.setBridgeImplementation(bridges_polygon);
    }

    function testMultiMessageAggregation() external {
        vm.selectFork(SRC_FORK_ID);

        vm.recordLogs();
        _sendMessageToPolygonUsingLz();
        _sendMessageToPolygonUsingHyperlane();

        Vm.Log[] memory logs = vm.getRecordedLogs();

        helper_hyperlane.help(MAILBOX, MAILBOX, DST_FORK_ID, logs);
        helper_lz.help(DST_ENDPOINT, 100000, DST_FORK_ID, logs);

        vm.selectFork(DST_FORK_ID);
        assertEq(
            messenger_polygon.receivedMessageQuorum(
                abi.encode(ETH_TO_POLYGON_MESSAGE)
            ),
            2
        );
    }

    function _sendMessageToPolygonUsingLz() internal {
        ILayerZeroEndpoint endpoint = ILayerZeroEndpoint(SRC_ENDPOINT);

        bytes memory remoteAndLocalAddresses = abi.encodePacked(
            address(target_lz),
            address(this)
        );
        endpoint.send{value: 1 ether}(
            DST_ID,
            remoteAndLocalAddresses,
            abi.encode(uint256(1)),
            payable(msg.sender),
            address(0),
            ""
        );
    }

    function _sendMessageToPolygonUsingHyperlane() internal {
        IMailbox mailbox = IMailbox(MAILBOX);
        bytes32 id = mailbox.dispatch(
            DST_DOMAIN,
            addressToBytes32(address(target_hyperlane)),
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
