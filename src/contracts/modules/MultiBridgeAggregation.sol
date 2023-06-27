// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {IAggregator} from "../interfaces/IAggregator.sol";
import {IModule} from "../interfaces/IModule.sol";
import {IEIP6170} from "../interfaces/IEIP6170.sol";
import {LIFIMessage} from "../libraries/Types.sol";

/// @title MultiBridgeAggregation
/// @dev module contains all the logic to send and receive messages
/// through multiple AMBs
contract MultiBridgeAggregation is IModule {
    /*///////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    address public immutable aggregator;

    mapping(address => uint256) public requiredQuorum;
    mapping(address => uint256[]) public messageBridges;
    mapping(uint256 => address) public bridgeAddresses;
    mapping(bytes => mapping(bytes => uint256)) public reachedQuorum;
    mapping(address => mapping(bytes => bytes)) public allowedRemote;

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _aggregator) {
        aggregator = _aggregator;
    }

    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IModule
    function setConfig(
        uint8 _configType,
        bytes memory _config,
        address _user
    ) external override {
        if (msg.sender != aggregator) {
            revert("INVALID_CONFIG_SETTER"); /// FIXME: add custom error later
        }

        /// @dev CONFIG_TYPE == 1: QUORUM
        if (_configType == 1) {
            requiredQuorum[_user] = abi.decode(_config, (uint256));
        }

        /// @dev CONFIG_TYPE == 2: ALLOWED_MESSAGE_BRIDGES
        if (_configType == 2) {
            messageBridges[_user] = abi.decode(_config, (uint256[]));
        }

        /// @dev CONFIG_TYPE == 3: ALLOWED_SENDER
        if (_configType == 3) {
            (bytes memory remoteAddress, bytes memory remoteChain) = abi.decode(
                _config,
                (bytes, bytes)
            );
            allowedRemote[_user][remoteChain] = remoteAddress;
        }
    }

    /// @inheritdoc IModule
    function sendMessage(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData,
        address _user
    ) external override {
        uint256[] memory bridgeIds = messageBridges[_user];

        /// FIXME: add validations
        for (uint256 i; i < bridgeIds.length; ) {
            IEIP6170(bridgeAddresses[bridgeIds[i]]).sendMessage(
                _dstChainId,
                allowedRemote[_user][_dstChainId],
                _message,
                _extraData
            );

            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IModule
    function receiveMessage(
        bytes memory _srcChainId,
        bytes memory _message
    ) external override {
        // address receiverAddress = abi.decode(_receiver, (address));
        // if (
        //     keccak256(allowedRemote[receiverAddress][_srcChainId]) !=
        //     keccak256(_sender)
        // ) {
        //     revert("INVALID_SENDER");
        // }
        // LIFIMessage memory m = abi.decode(_message, (LIFIMessage));
        // uint256 currentQuorum = ++reachedQuorum[_srcChainId][m.uniqueId];
        // if (currentQuorum >= requiredQuorum[receiverAddress]) {
        //     IAggregator(aggregator).xReceive(
        //         _srcChainId,
        //         receiverAddress,
        //         _message
        //     );
        // }
    }
}
