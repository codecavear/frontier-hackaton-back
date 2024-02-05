// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoffToken is ERC721, Ownable {
    uint256 private _tokenIds;

    IERC20 public erc20Token;
    uint256 public mintPrice;
    mapping(uint256 => uint256) public tokenMintPrices;
    uint8 public maxOperationLimit = 10;

    constructor(
        address _erc20Address,
        uint256 _mintPrice
    ) ERC721("CoffToken", "COFF") Ownable() {
        erc20Token = IERC20(_erc20Address);
        mintPrice = _mintPrice;
        _tokenIds = 0;
    }

    function mintToken(uint16 quantity) public returns (uint256 firstMintedId, uint16 mintedQuantity) {
        require(quantity > 0 && quantity <= maxOperationLimit, "Invalid quantity or exceeds the maximum limit of quantiy");        
        require(
            erc20Token.transferFrom(msg.sender, address(this), mintPrice * quantity),
            "USD payment failed"
        );

        firstMintedId = _tokenIds += 1;
        
        for(uint16 i = 0; i < quantity; i++) {
            _tokenIds += 1;
            _mint(msg.sender, _tokenIds);
            tokenMintPrices[_tokenIds] = mintPrice;
        }

        return (firstMintedId, quantity);
    }

    function redeemToken(uint16[] calldata tokenIds) public {
        require(tokenIds.length > 0 && tokenIds.length <= maxOperationLimit, "Invalid quantity or exceeds the maximum limit of quantiy");        

        uint256 totalRedeemAmount = 0;

        for(uint16 i = 0; i < tokenIds.length; i++) {
            uint16 tokenId = tokenIds[i];
            require(ownerOf(tokenId) == msg.sender, "You are not the owner");

            uint256 redeemAmount = tokenMintPrices[tokenId];
            require(redeemAmount > 0, "Error with token mint price");

            totalRedeemAmount += redeemAmount;

            _burn(tokenId);
            tokenMintPrices[tokenId] = 0;

        }

        require(
            erc20Token.transfer(msg.sender, totalRedeemAmount),
            "ERC20 transfer failed"
        );
    }

    function swapToken(uint16[] calldata tokenIds, address newOwner) public {
        require(tokenIds.length > 0 && tokenIds.length <= maxOperationLimit, "Invalid quantity or exceeds the maximum limit of quantiy");        

        for(uint16 i = 0; i < tokenIds.length; i++) {
             require(
                ownerOf(tokenIds[i]) == msg.sender,
                "Only the owner can swap the NFT"
            );

            safeTransferFrom(msg.sender, newOwner, tokenIds[i]);
            emit NFTSwapped(msg.sender, newOwner, tokenIds[i]);

        }
    }

    function setMintPrice(uint16 newPrice) public onlyOwner {
        mintPrice = newPrice;
    }

    function setMaxOperationLimit(uint8 newLimit) public onlyOwner {
        require(newLimit > 0, "The new limit must be greater than 0");
        maxOperationLimit = newLimit;
    }

    event NFTSwapped(
        address indexed oldOwner,
        address indexed newOwner,
        uint256 indexed tokenId
    );
}
