/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import {LayerZeroHelper} from "pigeon/layerzero/LayerZeroHelper.sol";
import {LayerZeroExample} from "src/contracts/examples/Layerzero.sol";

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

contract LayerZeroTest is Test {
    LayerZeroHelper helper;
    LayerZeroExample src;
    LayerZeroExample target;

    uint256 SRC_FORK_ID;
    uint256 DST_FORK_ID;

    uint256 constant ETH_TO_POLYGON_MESSAGE = 1;

    uint16 constant SRC_ID = 101;
    uint16 constant DST_ID = 109;

    address constant SRC_ENDPOINT = 0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675;
    address constant DST_ENDPOINT = 0x3c2269811836af69497E5F486A85D7316753cf62;

    string public SRC_CHAIN_RPC = vm.envString("ETHEREUM_RPC_URL");
    string public DST_CHAIN_RPC = vm.envString("POLYGON_RPC_URL");

    function setUp() external {
        SRC_FORK_ID = vm.createSelectFork(SRC_CHAIN_RPC, 16400467);
        src = new LayerZeroExample(SRC_ENDPOINT);
        helper = new LayerZeroHelper();

        DST_FORK_ID = vm.createSelectFork(DST_CHAIN_RPC, 38063686);
        target = new LayerZeroExample(DST_ENDPOINT);
    }

    function testCrossChainMessaging() external {
        vm.selectFork(SRC_FORK_ID);

        vm.recordLogs();
        _sendMessageToPolygon();

        Vm.Log[] memory logs = vm.getRecordedLogs();

        helper.help(DST_ENDPOINT, 100000, DST_FORK_ID, logs);

        vm.selectFork(DST_FORK_ID);
        assertEq(target.received(), ETH_TO_POLYGON_MESSAGE);
    }

    function _sendMessageToPolygon() internal {
        ILayerZeroEndpoint endpoint = ILayerZeroEndpoint(SRC_ENDPOINT);

        bytes memory remoteAndLocalAddresses = abi.encodePacked(
            address(target),
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
}
