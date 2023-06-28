/// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

import {Error} from "../../libraries/Error.sol";
import {IGAC} from "../../interfaces/IGAC.sol";
import {SenderImpl} from "./abstracts/SenderImpl.sol";
import {ReceiverImpl} from "./abstracts/ReceiverImpl.sol";
import {Setter} from "./state/Setter.sol";
import {IEIP6170} from "../../interfaces/IEIP6170.sol";
import {LIFIMessage} from "../../libraries/Types.sol";
import {IModule} from "../../interfaces/IModule.sol";

/// @title Hyperlane
/// @dev adapter contract for exposing Hyperlane AMB in a wrapped EIP6170 Interface
contract Hyperlane is Setter, SenderImpl, ReceiverImpl {
    /*///////////////////////////////////////////////////////////////
                            MODIFIER
    //////////////////////////////////////////////////////////////*/

    modifier onlyGAC() {
        if (!IGAC(getGac()).isCallerOwner(msg.sender)) {
            revert Error.INVALID_PREVILAGED_CALLER();
        }
        _;
    }

    /*///////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @dev _mailbox is the address of Mailbox
    /// @dev _gac is the address of GAC
    constructor(address _mailbox, address _gac) {
        setMailbox(_mailbox);
        setGac(_gac);
    }

    /*///////////////////////////////////////////////////////////////
                            PREVILAGES FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /// @dev can whitelist all their allowed chains
    /// @param _ambChainId is the message bridge chain id for that chain
    /// @param _internalChainId is the common identifier issued by LIFI
    /// note: caller should only be the GAC owner address
    function initializeChain(
        uint32 _ambChainId,
        bytes memory _internalChainId
    ) external onlyGAC {
        setChainId(_ambChainId, _internalChainId);
    }

    /// @dev helps owner authenticate the remote contract
    /// @param _remoteChainId is the chain id of the remote chain
    /// @param _path is abi encoded value of remote chain contract
    function configureTrustedRemote(
        uint32 _remoteChainId,
        bytes32 _path
    ) external onlyGAC {
        setTrustedRemote(_remoteChainId, _path);
    }

    /*///////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function receiveMessage(
        bytes memory _chainId,
        bytes memory,
        bytes memory _message,
        bytes memory
    ) public override(IEIP6170, ReceiverImpl) returns (bool) {
        /// @dev added for more validation
        if (msg.sender != getMailbox()) {
            revert Error.NOT_HYPERLANE_MAILBOX();
        }

        /// @dev decode LIFI message
        LIFIMessage memory decodedMessage = abi.decode(_message, (LIFIMessage));
        address module = IGAC(getGac()).getModule(
            abi.decode(decodedMessage.moduleId, (uint8))
        );

        /// @dev validates module (assumption: module id sent is receiving module id on dst chain)
        if (module == address(0)) {
            revert Error.INVALID_MODULE_ADDRESS();
        }

        /// @dev calls module after all validations
        IModule(module).receiveMessage(_chainId, _message);

        /// @dev if code reaches here then it is success
        return true;
    }
}
