// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./OwnableContract.sol";
import "./dualRoles/wrap/IWrapToERC4907Upgradeable.sol";
import "./dualRoles/IERC4907.sol";
import "./dualRoles/IERC4907Upgradeable.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ERC4907Factory is OwnableContract {
    event DeployERC4907(string name, string symbol);

    event DeployWrapToERC4907(
        address wrapNFT,
        string name,
        string symbol,
        address originalAddress
    );

    address public _ERC4907Implementation;
    address public _WrapToERC4907Implementation;

    constructor(
        address owner_,
        address admin_,
        address ERC4907Implementation_,
        address WrapToERC4907Implementation_
    ) {
        initOwnableContract(owner_, admin_);
        _ERC4907Implementation = ERC4907Implementation_;
        _WrapToERC4907Implementation = WrapToERC4907Implementation_;
    }

    function setERC4907Implementation(address ERC4907Implementation_)
        public
        onlyAdmin
    {
        _ERC4907Implementation = ERC4907Implementation_;
    }

    function setWrapToERC4907Implementation(
        address WrapToERC4907Implementation_
    ) public onlyAdmin {
        _WrapToERC4907Implementation = WrapToERC4907Implementation_;
    }

    function deployERC4907(string memory name, string memory symbol)
        public
        returns (address)
    {
        address _contract = Clones.clone(_ERC4907Implementation);
        IERC4907Upgradeable(_contract).initialize(name, symbol);

        emit DeployERC4907(name, symbol);
    }

    function deployWrapToERC4907(
        string memory name,
        string memory symbol,
        address originalAddress
    ) public returns (address wrapNFT) {
        require(
            IERC165(originalAddress).supportsInterface(
                type(IERC721).interfaceId
            ),
            "not ERC721"
        );
        require(
            !IERC165(originalAddress).supportsInterface(
                type(IERC4907).interfaceId
            ),
            "the NFT is IERC4907 already"
        );

        wrapNFT = Clones.clone(_WrapToERC4907Implementation);
        IWrapToERC4907Upgradeable(wrapNFT).initializeWrap(
            name,
            symbol,
            originalAddress
        );

        emit DeployWrapToERC4907(
            address(wrapNFT),
            name,
            symbol,
            originalAddress
        );
    }
}
