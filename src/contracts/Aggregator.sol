// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {IAggregator} from "./interfaces/IAggregator.sol";
import {IModule} from "./interfaces/IModule.sol";
import {IReceiver} from "./interfaces/IReceiver.sol";
import {Config, LIFIMessage} from "./libraries/Types.sol";
import {Error} from "./libraries/Error.sol";

/// @title LIFI Aggregator
/// @notice aggregates multiple AMB adapters & modules to allow applications to send / receive message
/// @dev interacts with the modules which in-turn interacts with AMB adapters to send & receive cross-chain messages
contract LIFIAggregator is IAggregator {
    /*///////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 public messageCounter;

    mapping(address => Config) public userApplicationConfig;
    mapping(uint8 => address) public module;
    mapping(address => uint8) public isModule;

    /*///////////////////////////////////////////////////////////////
                            MODIFIERS
    //////////////////////////////////////////////////////////////*/

    modifier onlyModule() {
        if (isModule[msg.sender] != 0) {
            revert("INVALID_MESSAGE_SENDER");
        }
        /// @dev add validations to make sure caller is a valid module
        _;
    }

    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IAggregator
    function setConfig(
        uint8 _sendModuleId,
        uint8 _receiveModuleId
    ) external override {
        userApplicationConfig[msg.sender] = Config(
            _sendModuleId,
            _receiveModuleId
        );
    }

    /// @inheritdoc IAggregator
    function setModuleConfig(
        uint8 _moduleId,
        uint8 _configType,
        bytes memory _config
    ) external override {
        IModule m = IModule(module[_moduleId]);
        m.setConfig(_configType, _config, msg.sender);
    }

    /// @inheritdoc IAggregator
    function xSend(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData
    ) external payable override {
        ++messageCounter;

        /// @dev get user configured module
        uint8 moduleId = getSendModuleId(msg.sender);
        IModule m = IModule(module[moduleId]);

        /// @dev validate module
        if (address(m) == address(0)) {
            revert Error.INVALID_MODULE_ADDRESS();
        }

        /// @dev construct LIFI message
        LIFIMessage memory encodedMessage = LIFIMessage(
            abi.encode(moduleId),
            abi.encode(msg.sender),
            _message,
            abi.encode(messageCounter)
        );

        /// @dev send message through user configured module
        m.sendMessage(
            _dstChainId,
            abi.encode(encodedMessage),
            _extraData,
            msg.sender
        );
    }

    /// @inheritdoc IAggregator
    function xReceive(
        bytes memory _srcChainId,
        bytes memory _message
    ) external override onlyModule {}

    /*///////////////////////////////////////////////////////////////
                            READ-ONLY FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IAggregator
    function getSendModuleId(
        address _user
    ) public view override returns (uint8 _sendModule) {
        Config memory config = userApplicationConfig[_user];

        _sendModule = config.sendModuleId;
    }

    /// @inheritdoc IAggregator
    function getReceiveModuleId(
        address _user
    ) public view override returns (uint8 _receiveModule) {
        Config memory config = userApplicationConfig[_user];

        _receiveModule = config.receiveModuleId;
    }
}
