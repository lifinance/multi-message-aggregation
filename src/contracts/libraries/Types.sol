// SPDX-License-Identifier: Apache-3.0
pragma solidity ^0.8.19;

/// @dev is a common file for all data types used across
/// the entire code-base

struct Config {
    uint8 sendModuleId;
    uint8 receiveModuleId;
}

struct LIFIMessage {
    bytes moduleId;
    bytes sender;
    bytes message;
    bytes uniqueId;
}
