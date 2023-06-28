// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

/// @dev imports from Pigeon Helper (Facilitate State Transfer Mocks)
import {LayerZeroHelper} from "pigeon/layerzero/LayerZeroHelper.sol";
import {HyperlaneHelper} from "pigeon/hyperlane/HyperlaneHelper.sol";

import {GAC} from "../contracts/controllers/GAC.sol";
import {LIFIAggregator} from "../contracts/Aggregator.sol";
import {MultiBridgeAggregation} from "../contracts/modules/MultiBridgeAggregation.sol";

import {LayerZero} from "../contracts/adapters/layerzero/LayerZero.sol";
import {Hyperlane} from "../contracts/adapters/hyperlane/Hyperlane.sol";

/// @dev tests setup is established between ETHEREUM & POLYGON
/// @dev supports LayerZero & Hyperlane through Pigeon

/// @dev can inherit the setup in their tests
abstract contract Setup is Test {
    /*///////////////////////////////////////////////////////////////
                            CONSTANT VARIABLES
    //////////////////////////////////////////////////////////////*/
    address constant LAYERZERO_ETH_ENDPOINT =
        0x66A71Dcef29A0fFBDBE3c6a460a3B5BC225Cd675;
    address constant LAYERZERO_POLYGON_ENDPOINT =
        0x3c2269811836af69497E5F486A85D7316753cf62;

    address constant HYPERLANE_MAILBOX =
        0x35231d4c2D8B8ADcB5617A638A0c4548684c7C70;
    address constant HYPERLANE_IGP = 0xdE86327fBFD04C4eA11dC0F270DA6083534c2582;

    /*///////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 public SRC_FORK_ID;
    uint256 public DST_FORK_ID;

    uint256[] public availableForks;

    string public SRC_CHAIN_RPC = vm.envString("ETHEREUM_RPC_URL");
    string public DST_CHAIN_RPC = vm.envString("POLYGON_RPC_URL");

    mapping(uint256 forkId => mapping(uint256 bridgeId => address bridgeHelper))
        public bridgeHelper;

    mapping(uint256 forkId => mapping(uint256 bridgeId => address bridgeAdapter))
        public bridgeAdapter;
    mapping(uint256 forkId => mapping(bytes => address)) public contractAddress;

    /*///////////////////////////////////////////////////////////////
                                SETUP
    //////////////////////////////////////////////////////////////*/

    function setUp() public virtual {
        /// @dev src chain is Ethereum
        SRC_FORK_ID = vm.createSelectFork(SRC_CHAIN_RPC, 16400467);
        availableForks.push(SRC_FORK_ID);
        _createContract(SRC_FORK_ID, LAYERZERO_ETH_ENDPOINT);

        /// @dev dst chain is Polygon
        DST_FORK_ID = vm.createSelectFork(DST_CHAIN_RPC, 38063686);
        availableForks.push(DST_FORK_ID);
        _createContract(DST_FORK_ID, LAYERZERO_POLYGON_ENDPOINT);

        _configureLayerZeroRemotes();
        _configureHyperlaneRemotes();
    }

    /*///////////////////////////////////////////////////////////////
                            INTERNAL HELPERS
    //////////////////////////////////////////////////////////////*/
    function _createContract(uint256 forkid, address lzEndpoint) internal {
        /// @dev bridge id 1 = Layerzero
        /// @dev bridge id 2 = Hyperlane
        bridgeHelper[forkid][1] = address(new LayerZeroHelper());
        bridgeHelper[forkid][2] = address(new HyperlaneHelper());

        /// @dev deploy GAC
        contractAddress[forkid][abi.encode("GAC")] = address(new GAC());

        /// @dev deploy aggregator
        contractAddress[forkid][abi.encode("AGGREGATOR")] = address(
            new LIFIAggregator(contractAddress[forkid][abi.encode("GAC")])
        );

        /// @dev deploy multi bridge aggregation
        contractAddress[forkid][abi.encode("MODULE1")] = address(
            new MultiBridgeAggregation(
                contractAddress[forkid][abi.encode("AGGREGATOR")],
                1,
                contractAddress[forkid][abi.encode("GAC")]
            )
        );

        /// @dev add module to gac
        GAC(contractAddress[forkid][abi.encode("GAC")]).configureNewModule(
            1,
            contractAddress[forkid][abi.encode("MODULE1")]
        );

        /// @dev add aggregator to gac
        GAC(contractAddress[forkid][abi.encode("GAC")]).configureAggregator(
            contractAddress[forkid][abi.encode("AGGREGATOR")]
        );

        /// @dev deploy LayerZero adapter
        bridgeAdapter[forkid][1] = address(
            new LayerZero(
                lzEndpoint,
                contractAddress[forkid][abi.encode("GAC")]
            )
        );

        /// @dev deploy Hyperlane adapter
        bridgeAdapter[forkid][2] = address(
            new Hyperlane(
                HYPERLANE_MAILBOX,
                contractAddress[forkid][abi.encode("GAC")]
            )
        );

        /// @dev add new bridges to gac
        GAC(contractAddress[forkid][abi.encode("GAC")]).configureNewBridge(
            1,
            bridgeAdapter[forkid][1]
        );

        GAC(contractAddress[forkid][abi.encode("GAC")]).configureNewBridge(
            2,
            bridgeAdapter[forkid][2]
        );

        /// @dev initialize both available chains
        LayerZero(bridgeAdapter[forkid][1]).initializeChain(
            101,
            abi.encode("ETHEREUM")
        );
        LayerZero(bridgeAdapter[forkid][1]).initializeChain(
            109,
            abi.encode("POLYGON")
        );

        Hyperlane(bridgeAdapter[forkid][2]).initializeChain(
            1,
            abi.encode("ETHEREUM")
        );
        Hyperlane(bridgeAdapter[forkid][2]).initializeChain(
            137,
            abi.encode("POLYGON")
        );
    }

    function _configureLayerZeroRemotes() internal {
        vm.selectFork(SRC_FORK_ID);

        LayerZero(bridgeAdapter[SRC_FORK_ID][1]).configureTrustedRemote(
            109,
            abi.encodePacked(
                bridgeAdapter[DST_FORK_ID][1],
                bridgeAdapter[SRC_FORK_ID][1]
            )
        );

        vm.selectFork(DST_FORK_ID);

        LayerZero(bridgeAdapter[DST_FORK_ID][1]).configureTrustedRemote(
            101,
            abi.encodePacked(
                bridgeAdapter[SRC_FORK_ID][1],
                bridgeAdapter[DST_FORK_ID][1]
            )
        );
    }

    function _configureHyperlaneRemotes() internal {
        vm.selectFork(SRC_FORK_ID);

        Hyperlane(bridgeAdapter[SRC_FORK_ID][2]).configureTrustedRemote(
            137,
            addressToBytes32(bridgeAdapter[DST_FORK_ID][2])
        );

        vm.selectFork(DST_FORK_ID);

        Hyperlane(bridgeAdapter[DST_FORK_ID][2]).configureTrustedRemote(
            1,
            addressToBytes32(bridgeAdapter[SRC_FORK_ID][2])
        );
    }

    function addressToBytes32(address _addr) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(_addr)));
    }
}
