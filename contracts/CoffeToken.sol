// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoffeToken is ERC721, Ownable, ReentrancyGuard {
    uint256 private _tokenIds;

    IERC20 public usdcToken;
    uint256 public mintPrice;
    mapping(uint256 => uint256) public tokenPrices;

    constructor(
        address _usdcAddress,
        uint256 _mintPrice
    ) ERC721("CoffeToken", "COFFE") Ownable(msg.sender) {
        // Modificación aquí
        usdcToken = IERC20(_usdcAddress);
        mintPrice = _mintPrice;
        _tokenIds = 0;
    }

    function mintToken(
        address to
    ) public onlyOwner nonReentrant returns (uint256) {
        require(
            usdcToken.transferFrom(to, address(this), mintPrice),
            "USD payment failed"
        );

        _tokenIds += 1;
        uint256 newItemId = _tokenIds;
        _mint(to, newItemId);
        tokenPrices[newItemId] = mintPrice;

        return newItemId;
    }

    function redeemToken(uint256 tokenId) public nonReentrant {
        require(ownerOf(tokenId) == msg.sender, "Youre not the owner");
        require(
            usdcToken.transfer(msg.sender, tokenPrices[tokenId]),
            "USD transfer failed"
        );

        _burn(tokenId);
    }

    function swapCoffeNFT(
        uint256 tokenId,
        address newOwner
    ) public nonReentrant {
        require(
            ownerOf(tokenId) == msg.sender,
            "Only the owner can swap the NFT"
        );
        safeTransferFrom(msg.sender, newOwner, tokenId);

        emit NFTSwapped(msg.sender, newOwner, tokenId);
    }

    event NFTSwapped(
        address indexed oldOwner,
        address indexed newOwner,
        uint256 indexed tokenId
    );
}
