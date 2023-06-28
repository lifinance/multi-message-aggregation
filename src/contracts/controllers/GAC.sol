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
    mapping(uint256 => address) public bridgeAddresses;
    mapping(address => uint256) public bridgeId;

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/
    constructor() Ownable(msg.sender) {}

    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @inheritdoc IGAC
    function configureAggregator(
        address _aggregator
    ) external override onlyOwner {
        aggregator = _aggregator;
    }

    /// @inheritdoc IGAC
    function configureNewModule(
        uint8 _moduleId,
        address _module
    ) external override onlyOwner {
        module[_moduleId] = _module;
        moduleId[_module] = _moduleId;
    }

    /// @inheritdoc IGAC
    function configureNewBridge(
        uint256 _bridgeId,
        address _bridgeAddress
    ) external override onlyOwner {
        bridgeAddresses[_bridgeId] = _bridgeAddress;
        bridgeId[_bridgeAddress] = _bridgeId;
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

    /// @inheritdoc IGAC
    function getBridgeAddress(
        uint256 _bridgeId
    ) external view returns (address _bridge) {
        return bridgeAddresses[_bridgeId];
    }

    /// @inheritdoc IGAC
    function isCallerBridgeAdapter(
        address _caller
    ) external view returns (bool) {
        if (bridgeId[_caller] == 0) {
            return false;
        }

        return true;
    }
}
