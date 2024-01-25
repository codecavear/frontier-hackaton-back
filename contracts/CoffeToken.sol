// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CoffeToken is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    IERC20 public usdcToken;
    uint256 public mintPrice;
    mapping(uint256 => uint256) public tokenPrices;

    constructor(
        address _usdcAddress,
        uint256 _mintPrice
    ) ERC721("CoffeToken", "COFFE") {
        usdcToken = IERC20(_usdcAddress);
        mintPrice = _mintPrice;
    }

    function mintToken(
        address to
    ) public onlyOwner nonReentrant returns (uint256) {
        require(
            usdcToken.transferFrom(to, address(this), mintPrice),
            "Pago con USDC fallido"
        );

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(to, newItemId);
        tokenPrices[newItemId] = mintPrice;

        return newItemId;
    }

    function redeemToken(uint256 tokenId) public nonReentrant {
        require(
            ownerOf(tokenId) == msg.sender,
            "No eres el propietario del token"
        );
        require(
            usdcToken.transfer(msg.sender, tokenPrices[tokenId]),
            "Error en la transferencia de USDC"
        );

        _burn(tokenId);
    }

    function swapCoffeNFT(
        uint256 tokenId,
        address newOwner
    ) public nonReentrant {
        require(
            ownerOf(tokenId) == msg.sender,
            "Solo el propietario puede swapear el NFT"
        );
        safeTransferFrom(msg.sender, newOwner, tokenId);

        emit NFTSwapped(msg.sender, newOwner, tokenId);
    }

    // Evento para swapear el NFT
    event NFTSwapped(
        address indexed oldOwner,
        address indexed newOwner,
        uint256 indexed tokenId
    );
}
