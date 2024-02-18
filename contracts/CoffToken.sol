// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CoffToken is ERC721Enumerable, Ownable {
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

  function mintToken(
    uint16 quantity
  ) public returns (uint256 firstMintedId, uint16 mintedQuantity) {
    require(
      quantity > 0 && quantity <= maxOperationLimit,
      "Invalid quantity or exceeds the maximum limit of quantiy"
    );
    require(
      erc20Token.transferFrom(msg.sender, address(this), mintPrice * quantity),
      "USD payment failed"
    );

    firstMintedId = _tokenIds += 1;

    for (uint16 i = 0; i < quantity; i++) {
      _tokenIds += 1;
      _mint(msg.sender, _tokenIds);
      tokenMintPrices[_tokenIds] = mintPrice;
    }

    emit TokensMinted(msg.sender, quantity, firstMintedId);

    return (firstMintedId, quantity);
  }

  function redeemToken(uint16 quantity) public {
    require(quantity > 0, "Invalid quantity");
    require(quantity <= balanceOf(msg.sender), "Not enough tokens owned");

    uint256 totalRedeemAmount = 0;
    for (uint16 i = 0; i < quantity; i++) {
      /* burn update the index */
      uint256 tokenId = tokenOfOwnerByIndex(msg.sender, 0);
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

    emit TokensRedeemed(msg.sender, quantity, totalRedeemAmount);
  }

  function transferToken(uint16 quantity, address newOwner) public {
    require(quantity > 0, "Invalid quantity");
    require(quantity <= balanceOf(msg.sender), "Not enough tokens owned");

    for (uint16 i = 0; i < quantity; i++) {
      uint256 tokenId = tokenOfOwnerByIndex(msg.sender, 0);
      safeTransferFrom(msg.sender, newOwner, tokenId);
    }

    emit TokensTransferred(msg.sender, newOwner, quantity);
  }

  function setMintPrice(uint16 newPrice) public onlyOwner {
    mintPrice = newPrice;
  }

  function setMaxOperationLimit(uint8 newLimit) public onlyOwner {
    require(newLimit > 0, "The new limit must be greater than 0");
    maxOperationLimit = newLimit;
  }

  event TokensTransferred(
    address indexed from,
    address indexed to,
    uint256 quantity
  );
  event TokensMinted(
    address indexed to,
    uint256 quantity,
    uint256 firstMintedId
  );
  event TokensRedeemed(
    address indexed from,
    uint256 quantity,
    uint256 totalRedeemAmount
  );
}
