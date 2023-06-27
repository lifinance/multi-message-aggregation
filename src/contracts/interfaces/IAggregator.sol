// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

/// @title Interface For LIFI Aggregator
interface IAggregator {
    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev handles the routing of messages to user configured module
    /// @param _dstChainId is the LIFI declared chain id of any destination chain
    /// @param _message is the raw cross-chain message to be sent
    /// @param _extraData is any AMB specific extra data (declared on the fly)
    function xSend(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData
    ) external payable;

    /// @dev handles delivering messages from modules to user application
    /// @param _srcChainId is the chain id from which the message is sent
    /// @param _message is the LIFI encoded message with more details before delivery
    /// note: can only be called by registered modules
    function xReceive(bytes memory _srcChainId, bytes memory _message) external;

    /// @dev allows user applications to configure their default send and receive modules
    /// @param _sendModuleId is the id of the send module
    /// @param _receiveModuleId is the id of the receive module
    function setConfig(uint8 _sendModuleId, uint8 _receiveModuleId) external;

    /// @dev allows user application to update individual module's specific send
    /// @param _moduleId is the identifier of the module
    /// @param _configType is the identifier of the config (REFER MODULE)
    /// @param _config is the encoded config (REFER MODULE)
    function setModuleConfig(
        uint8 _moduleId,
        uint8 _configType,
        bytes memory _config
    ) external;

    /*///////////////////////////////////////////////////////////////
                            READ-ONLY FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev returns the configured receive module for any user
    /// @param _user is the address of the user
    /// @return _receiveModuleId is the identifier of the receive module
    function getReceiveModuleId(
        address _user
    ) external view returns (uint8 _receiveModuleId);

    /// @dev returns the configured send module for any user
    /// @param _user is the address of the user
    /// @return _sendModuleId is the identifier of the send module
    function getSendModuleId(
        address _user
    ) external view returns (uint8 _sendModuleId);
}
