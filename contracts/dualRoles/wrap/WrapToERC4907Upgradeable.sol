// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "../ERC4907Upgradeable.sol";
import "./IWrapNFT.sol";

contract WrapToERC4907Upgradeable is ERC4907Upgradeable, IWrapNFT {
    address private _originalAddress;

    address private _doNFTAddress;

    function initializeWrap(
        string memory name_,
        string memory symbol_,
        address originalAddress_
    ) public virtual initializer {
        __ERC721_init(name_, symbol_);
        _originalAddress = originalAddress_;
    }

    function originalAddress() public view returns (address) {
        return _originalAddress;
    }

    function stake(uint256 tokenId) public returns (uint256) {
        require(
            onlyApprovedOrOwner(msg.sender, _originalAddress, tokenId),
            "only approved or owner"
        );
        address lastOwner = IERC721(_originalAddress).ownerOf(tokenId);
        IERC721(_originalAddress).safeTransferFrom(
            lastOwner,
            address(this),
            tokenId
        );
        _mint(lastOwner, tokenId);
        emit Stake(msg.sender, _originalAddress, tokenId);
        return tokenId;
    }

    function redeem(uint256 tokenId) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        IERC721(_originalAddress).safeTransferFrom(
            address(this),
            ownerOf(tokenId),
            tokenId
        );
        _burn(tokenId);
        emit Redeem(msg.sender, _originalAddress, tokenId);
    }

    function onlyApprovedOrOwner(
        address spender,
        address nftAddress,
        uint256 tokenId
    ) internal view returns (bool) {
        address owner = IERC721(nftAddress).ownerOf(tokenId);
        require(
            owner != address(0),
            "ERC721: operator query for nonexistent token"
        );
        return (spender == owner ||
            IERC721(nftAddress).getApproved(tokenId) == spender ||
            IERC721(nftAddress).isApprovedForAll(owner, spender));
    }

    function originalOwnerOf(uint256 tokenId)
        public
        view
        virtual
        returns (address owner)
    {
        owner = IERC721(_originalAddress).ownerOf(tokenId);
        if (owner == address(this)) {
            owner = ownerOf(tokenId);
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return IERC721Metadata(_originalAddress).tokenURI(tokenId);
    }

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external pure virtual override returns (bytes4) {
        bytes4 received = 0x150b7a02;
        return received;
    }

    /// @dev See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override
        returns (bool)
    {
        return
            interfaceId == type(IWrapNFT).interfaceId ||
            interfaceId == type(IERC4907).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}
