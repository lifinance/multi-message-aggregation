pragma solidity ^0.8.19;

import {IAggregator} from "./interfaces/IAggregator.sol";
import {IModule} from "./interfaces/IModule.sol";
import {IReceiver} from "./interfaces/IReceiver.sol";

contract LIFIAggregator is IAggregator {
    uint256 messageCounter;

    struct Config {
        uint8 sendModuleId;
        uint8 receiveModuleId;
    }

    struct LIFIMessage {
        bytes moduleId;
        bytes sender;
        bytes message;
        bytes uniqueId;
    }

    modifier onlyModule() {
        if (isModule[msg.sender] != 0) {
            revert("INVALID_MESSAGE_SENDER");
        }
        /// @dev add validations to make sure caller is a valid module
        _;
    }

    mapping(address => Config) public userApplicationConfig;
    mapping(uint8 => address) public module;
    mapping(address => uint8) public isModule;

    function setConfig(uint8 _sendeModuleId, uint8 _receiveModuleId) external {
        userApplicationConfig[msg.sender] = Config(
            _sendeModuleId,
            _receiveModuleId
        );
    }

    function setModuleConfig(
        uint8 _moduleId,
        uint8 _configType,
        bytes memory _config
    ) external {
        IModule m = IModule(module[_moduleId]);
        m.setConfig(_configType, _config, msg.sender);
    }

    function xSend(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData
    ) external payable override {
        uint8 moduleId = getSendModuleId(msg.sender);

        IModule m = IModule(module[moduleId]);

        ++messageCounter;
        LIFIMessage memory encodedMessage = LIFIMessage(
            abi.encode(moduleId),
            abi.encode(msg.sender),
            _message,
            abi.encode(messageCounter)
        );
        m.sendMessage(
            _dstChainId,
            abi.encode(encodedMessage),
            _extraData,
            msg.sender
        );
    }

    function xReceive(
        bytes memory _srcChainId,
        address _receiver,
        bytes memory _message
    ) external override onlyModule {
        if (getReceiveModuleId(_receiver) != isModule[msg.sender]) {
            revert("INVALID_MODULE");
        }
        /// @dev call user application.xReceive()
        IReceiver(_receiver).xReceive(_srcChainId, _message);
    }

    function getSendModuleId(
        address _user
    ) public view returns (uint8 _sendModule) {
        Config memory config = userApplicationConfig[_user];

        _sendModule = config.sendModuleId;
    }

    function getReceiveModuleId(
        address _user
    ) public view returns (uint8 _receiveModule) {
        Config memory config = userApplicationConfig[_user];

        _receiveModule = config.receiveModuleId;
    }
}
