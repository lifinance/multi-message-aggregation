/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";
import {Error} from "../../libraries/Error.sol";
import {IGAC} from "../../interfaces/IGAC.sol";
import {ILayerZeroEndpoint} from "./interface/ILayerZeroEndpoint.sol";
import {ILayerZeroUserApplicationConfig} from "./interface/ILayerZeroUserApplicationConfig.sol";

/// @title LayerZero
/// @dev adapter contract for exposing LayerZero AMB in a wrapped EIP6170 Interface
contract LayerZero is
    Setter,
    SenderImpl,
    ReceiverImpl,
    ILayerZeroUserApplicationConfig
{
    /*///////////////////////////////////////////////////////////////
                            MODIFIER
    //////////////////////////////////////////////////////////////*/

    modifier onlyGAC() {
        if (msg.sender != IGAC(getGac()).owner()) {
            revert Error.INVALID_PREVILAGED_CALLER();
        }
        _;
    }

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param _endpoint is the address of LayerZero Endpoint
    constructor(address _endpoint, address _gac) {
        setEndpoint(_endpoint);
        setGac(_gac);
    }

    /*///////////////////////////////////////////////////////////////
                            PREVILAGED FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev can whitelist all their allowed chains
    /// @param _ambChainId is the message bridge chain id for that chain
    /// @param _internalChainId is the common identifier issued by LIFI
    /// note: caller should only be the GAC owner address
    function initializeChain(
        uint16 _ambChainId,
        bytes memory _internalChainId
    ) external onlyGAC {
        setChainId(_ambChainId, _internalChainId);
    }

    /// @dev helps owner authenticate the remote contract
    /// @param _remoteChainId is the chain id of the remote chain
    /// @param _path is abi encoded values of both src chain and remote chain contracts
    function configureTrustedRemote(
        uint16 _remoteChainId,
        bytes calldata _path
    ) external onlyGAC {
        setTrustedRemote(_remoteChainId, _path);
    }

    /// @inheritdoc ILayerZeroUserApplicationConfig
    function setConfig(
        uint16 _version,
        uint16 _chainId,
        uint _configType,
        bytes calldata _config
    ) external override onlyGAC {
        ILayerZeroEndpoint(getEndpoint()).setConfig(
            _version,
            _chainId,
            _configType,
            _config
        );
    }

    /// @inheritdoc ILayerZeroUserApplicationConfig
    function setSendVersion(uint16 _version) external override onlyGAC {
        ILayerZeroEndpoint(getEndpoint()).setSendVersion(_version);
    }

    /// @inheritdoc ILayerZeroUserApplicationConfig
    function setReceiveVersion(uint16 _version) external override onlyGAC {
        ILayerZeroEndpoint(getEndpoint()).setReceiveVersion(_version);
    }

    /// @inheritdoc ILayerZeroUserApplicationConfig
    function forceResumeReceive(
        uint16 _srcChainId,
        bytes calldata _srcAddress
    ) external override onlyGAC {
        ILayerZeroEndpoint(getEndpoint()).forceResumeReceive(
            _srcChainId,
            _srcAddress
        );
    }
}
