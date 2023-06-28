// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import {IAggregator} from "../../contracts/interfaces/IAggregator.sol";
import {IReceiver} from "../../contracts/interfaces/IReceiver.sol";

/// @dev is a mock MMA application
contract MockApp is IReceiver {
    /*///////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint8 public constant defaultModule = 1;
    IAggregator public aggregator;
    bytes public message;

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _aggregator) {
        aggregator = IAggregator(_aggregator);
    }

    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function xSend(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData
    ) external payable {
        aggregator.xSend{value: msg.value}(_dstChainId, _message, _extraData);
    }

    function xReceive(bytes memory, bytes memory _message) external override {
        message = _message;
    }

    function setConfig() external {
        aggregator.setConfig(1, 1);
    }

    function setModuleConfig(uint8 _configType, bytes memory _config) external {
        aggregator.setModuleConfig(defaultModule, _configType, _config);
    }
}
