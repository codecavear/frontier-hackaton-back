// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoffeToken is ERC721, Ownable {
    uint256 private _tokenIds;

    IERC20 public usdcToken;
    uint256 public mintPrice;
    mapping(uint256 => uint256) public tokenPrices;

    constructor(
        address _usdcAddress,
        uint256 _mintPrice
    ) ERC721("CoffeToken", "COFFE") Ownable() {
        usdcToken = IERC20(_usdcAddress);
        mintPrice = _mintPrice;
        _tokenIds = 0;
    }

    function mintToken() public returns (uint256) {
        require(
            usdcToken.transferFrom(msg.sender, address(this), mintPrice),
            "USD payment failed"
        );

        _tokenIds += 1;
        uint256 newItemId = _tokenIds;
        _mint(msg.sender, newItemId);
        tokenPrices[newItemId] = mintPrice;

        return newItemId;
    }

    function redeemToken(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner");
        require(
            usdcToken.transfer(msg.sender, tokenPrices[tokenId]),
            "USD transfer failed"
        );

        _burn(tokenId);
        tokenPrices[tokenId] = 0;
    }

    function swapCoffeNFT(uint256 tokenId, address newOwner) public {
        require(
            ownerOf(tokenId) == msg.sender,
            "Only the owner can swap the NFT"
        );
        safeTransferFrom(msg.sender, newOwner, tokenId);

        emit NFTSwapped(msg.sender, newOwner, tokenId);
    }

    function setMintPrice(uint256 newPrice) public onlyOwner {
        mintPrice = newPrice;
    }

    event NFTSwapped(
        address indexed oldOwner,
        address indexed newOwner,
        uint256 indexed tokenId
    );
}
