// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

/// @title Interface for GAC
interface IGAC {
    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev allows owner to configure a new module
    /// @dev _moduleId is the unique id of the module
    /// @dev _module is the address of the module
    function configureNewModule(uint8 _moduleId, address _module) external;

    /// @dev allows owner to configure the aggregator contract
    /// @param _aggregator is the address of aggregator
    function configureAggregator(address _aggregator) external;

    /// @dev allows owner to configure the new bridge contract
    /// @param _bridgeId is the id of bridge
    /// @param _bridgeAddress is the address of the bridge
    function configureNewBridge(
        uint256 _bridgeId,
        address _bridgeAddress
    ) external;

    /*///////////////////////////////////////////////////////////////
                            READ-ONLY FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev returns if caller is owner
    /// @param _caller is the address of the caller to validate
    function isCallerOwner(address _caller) external view returns (bool);

    /// @dev returns the aggregator contract address
    function aggregator() external view returns (address);

    /// @dev returns module address for module id
    /// @param _moduleId is the id of the module
    /// @return _module is the address of the module
    function getModule(uint8 _moduleId) external view returns (address _module);

    /// @dev returns the bridge address
    /// @param _bridgeId is the id of the bridge
    function getBridgeAddress(
        uint256 _bridgeId
    ) external view returns (address _bridge);

    /// @dev returns module id for module address
    /// @param _module is the address of the module
    /// @return _moduleId is the id of the module
    function getModuleId(
        address _module
    ) external view returns (uint8 _moduleId);

    /// @dev returns if the caller is a valid module
    /// @param _module is the address of the module
    /// @return bool indicating the validity of the module
    function isModule(address _module) external view returns (bool);

    /// @dev returns if caller is a valid bridge adapter
    /// @param _caller is the address of the caller
    /// @return bool indicating the validity of the bridge adapter
    function isCallerBridgeAdapter(
        address _caller
    ) external view returns (bool);
}
