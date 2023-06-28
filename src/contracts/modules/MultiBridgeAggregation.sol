// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {IAggregator} from "../interfaces/IAggregator.sol";
import {IModule} from "../interfaces/IModule.sol";
import {IEIP6170} from "../interfaces/IEIP6170.sol";
import {LIFIMessage} from "../libraries/Types.sol";
import {Error} from "../libraries/Error.sol";
import {IGAC} from "../interfaces/IGAC.sol";

import "forge-std/console.sol";

/// @title MultiBridgeAggregation
/// @dev module contains all the logic to send and receive messages
/// through multiple AMBs
contract MultiBridgeAggregation is IModule {
    /*///////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    address public immutable aggregator;
    address public immutable gac;
    uint8 public immutable moduleId;

    uint256 public messageCounter;

    mapping(address => uint256) public requiredQuorum;
    mapping(address => uint256[]) public messageBridges;
    mapping(bytes => mapping(bytes => uint256)) public reachedQuorum;
    mapping(address => mapping(bytes => bytes)) public allowedRemote;

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _aggregator, uint8 _moduleId, address _gac) {
        aggregator = _aggregator;
        moduleId = _moduleId;
        gac = _gac;
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
    ) external payable override {
        uint256[] memory bridgeIds = messageBridges[_user];
        bytes memory receiver = allowedRemote[_user][_dstChainId];

        /// @dev increment messages sent via module
        ++messageCounter;

        /// @dev construct message
        LIFIMessage memory messageToBeEncoded = LIFIMessage(
            abi.encode(moduleId),
            abi.encode(_user),
            receiver,
            _message,
            abi.encode(messageCounter) /// @dev can improve uniqueness further
        );

        /// FIXME: add validations
        for (uint256 i; i < bridgeIds.length; ) {
            IEIP6170(IGAC(gac).getBridgeAddress(bridgeIds[i])).sendMessage{
                value: msg.value
            }(
                _dstChainId,
                allowedRemote[_user][_dstChainId],
                abi.encode(messageToBeEncoded),
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
        /// @dev decode LIFI message
        LIFIMessage memory decodedMessage = abi.decode(_message, (LIFIMessage));

        bytes memory packedRemote = decodedMessage.receiver;

        address receiverAddress;
        address senderAddress;

        assembly {
            receiverAddress := mload(add(packedRemote, 0x14))
        }

        bytes memory packedLocalRemote = allowedRemote[receiverAddress][
            _srcChainId
        ];

        assembly {
            senderAddress := mload(add(packedLocalRemote, 0x14))
        }

        if (
            keccak256(abi.encode(senderAddress)) !=
            keccak256(decodedMessage.sender)
        ) {
            revert Error.INVALID_SOURCE_SENDER();
        }

        uint256 currentQuorum = ++reachedQuorum[_srcChainId][
            decodedMessage.uniqueId
        ];

        /// @dev is quorum passed send message to user application
        if (currentQuorum >= requiredQuorum[receiverAddress]) {
            IAggregator(aggregator).xReceive(
                _srcChainId,
                receiverAddress,
                decodedMessage.message
            );
        }
    }
}
