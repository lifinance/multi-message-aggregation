// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

import "openzeppelin-contracts/contracts/access/Ownable.sol";
import {IGAC} from "../interfaces/IGAC.sol";

/// @title GAC (Global Access Control)
/// @dev controls all previlaged function calls
contract GAC is IGAC, Ownable {
    /*///////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IGAC
    address public override aggregator;

    mapping(uint8 => address) public module;
    mapping(address => uint8) public moduleId;

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor(address _aggregator) {
        aggregator = _aggregator;
    }

    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IGAC
    function configureNewModule(
        uint8 _moduleId,
        address _module
    ) external override {
        module[_moduleId] = _module;
        moduleId[_module] = _moduleId;
    }

    /*///////////////////////////////////////////////////////////////
                            READ-ONLY FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IGAC
    function getModule(
        uint8 _moduleId
    ) external view override returns (address _module) {
        return module[_moduleId];
    }

    /// @inheritdoc IGAC
    function getModuleId(
        address _module
    ) external view override returns (uint8 _moduleId) {
        return moduleId[_module];
    }

    /// @inheritdoc IGAC
    function isModule(address _module) external view override returns (bool) {
        if (moduleId[_module] == 0) {
            return false;
        }

        return true;
    }

    /// @inheritdoc IGAC
    function isCallerOwner(
        address _caller
    ) external view override returns (bool) {
        if (_caller != owner()) {
            return false;
        }

        return true;
    }
}
