// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

/// @title Interface For LIFI Modules
/// @dev LIFI Modules are logic for individual sender / receiver modules
/// note: are gated and can be deployed only by LIFI
interface IModule {
    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev allows users to configure module specific configs
    /// @param _configType is the type of configuration
    /// @param _config is the encoded configuration
    /// @param _user is the address of the user
    /// note: can be called only by aggregator contract
    function setConfig(
        uint8 _configType,
        bytes memory _config,
        address _user
    ) external;

    /// @dev allows aggregator to send message
    /// @param _dstChainId is the LIFI allocated chain id of the receiving chain
    /// @param _message is the cross-chain LIFI encoded message
    /// @param _extraData is any extraData for module
    /// @param _user is the address of the sender
    function sendMessage(
        bytes memory _dstChainId,
        bytes memory _message,
        bytes memory _extraData,
        address _user
    ) external;

    /// @dev allows module to receive message from amb adapters
    /// @param _srcChainId is the LIFI allocated chain id of the sending chain
    /// @param _message is the cross-chain LIFI encoded message
    function receiveMessage(
        bytes memory _srcChainId,
        bytes memory _message
    ) external;
}
