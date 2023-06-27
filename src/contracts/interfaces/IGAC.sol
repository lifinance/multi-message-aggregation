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

    /// @dev returns if the caller is a valid module
    /// @param _module is the address of the module
    /// @return bool indicating the validity of the module
    function isModule(address _module) external view returns (bool);
}
