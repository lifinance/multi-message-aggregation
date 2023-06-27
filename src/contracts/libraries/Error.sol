// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

library Error {
    /*///////////////////////////////////////////////////////////////
                    ERROR CODES FOR AUTH
    //////////////////////////////////////////////////////////////*/

    /// @dev reverts when the caller is not the previlaged caller
    error INVALID_PREVILAGED_CALLER();

    /*///////////////////////////////////////////////////////////////
                    ERROR CODES FOR ADAPTERS
    //////////////////////////////////////////////////////////////*/

    /// @dev reverts when the caller is not layerzero endpoint
    error NOT_LAYERZERO_ENDPOINT();

    /// @dev reverts if the caller on source chain is not authenticated
    error INVALID_SOURCE_SENDER();

    /// @dev reverts if the nonce/unique id is already used
    error USED_UNIQUE_ID();

    /*///////////////////////////////////////////////////////////////
                    ERROR CODES FOR AGGREGATOR
    //////////////////////////////////////////////////////////////*/

    /// @dev reverts if module address is zero
    error INVALID_MODULE_ADDRESS();

    /// @dev revert if receiver module address is mismatched
    error INVALID_RECEIVER_MODULE();
}
