// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.19;

library Error {
    /*///////////////////////////////////////////////////////////////
                    ERROR CODES FOR AUTH
    //////////////////////////////////////////////////////////////*/

    /// @dev reverts when the caller is not the previlaged caller
    error INVALID_PREVILAGED_CALLER();
}
