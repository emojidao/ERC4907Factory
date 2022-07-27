// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IWrapToERC4907Upgradeable {
    function initializeWrap(
        string memory name_,
        string memory symbol_,
        address originalAddress_
    ) external;
}
