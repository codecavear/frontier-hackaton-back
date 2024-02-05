# CoffeeToken Smart Contract

## Introduction

This project focuses on creating and deploying the `CoffeeToken` smart contract on the Avalanche Fuji Network through Truffle. `CoffeeToken` is an ERC721 token offering features such as minting in exchange for USDC, token redemption, and ownership transfer.

## Requirements

To work with this project, you will need:

- Node.js and npm installed.
- Truffle Suite.
- An Avalanche Fuji testnet account with the required cryptocurrencies.
- `@openzeppelin/contracts` version `^4.9.3`.

## Configuration

### Environment Variables

Create a `.env` file in the root directory of the project with the following variables:

- `MNEMONIC`: Your wallet mnemonic.
- `USDC_ADDRESS`: The contract address of the USDC token on the Avalanche network.
- `URL_PROVIDER`: The URL of the Avalanche network provider.

## Deployment

Follow these steps to deploy the `CoffeeToken` smart contract to the Avalanche Fuji Network:

1. **Compiling the Contract**: 
   - Run the command `truffle compile` to compile the smart contract. This step will generate the necessary artifacts for deployment.

2. **Basic Deployment**:
   - Use `truffle migrate --network fuji` to deploy the contract to the Fuji testnet. This command will perform the standard deployment process.

3. **Verbose Deployment (Optional)**:
   - For a more detailed deployment process, including additional RPC (Remote Procedure Call) information, use the command `truffle migrate --network fuji --verbose-rpc`. This can be particularly useful for debugging or when you need more insight into the deployment process.
4. **Verify erc721 contract (Optional)**:
   - Command to verify the contract: `truffle run verify CoffToken --network fuji`


## Contract Usage

### Minting Tokens
- **Function**: `mintToken(address to)`
- **Description**: This function allows any user to mint a new CoffeeToken. The minting process requires the user to pay the set price in USDC. The contract transfers the USDC from the user to the CoffeeToken contract as payment.
- **Usage**: `mintToken(<recipient_address>)`

### Redeeming Tokens
- **Function**: `redeemToken(uint256 tokenId)`
- **Description**: Token holders can redeem their CoffeeToken tokens using this function. It transfers the corresponding USDC amount back to the token holder and then burns the NFT.
- **Usage**: `redeemToken(<tokenId>)`

### Swapping Tokens
- **Function**: `swapCoffeNFT(uint256 tokenId, address newOwner)`
- **Description**: This function allows token owners to transfer their `CoffeeToken` to a new owner. The current owner must specify the token ID (`tokenId`) and the address of the new owner (`newOwner`).
- **Usage**: `swapCoffeNFT(<tokenId>, <new_owner_address>)`

## Resources
- [Avalanche Truffle Documentation](https://la-url-aqui)
- [OpenZeppelin Contracts](https://la-otra-url-aqui)


## Known Issues and Solutions

### Solidity Version Compatibility
- **Issue**: A compatibility problem with Solidity version `0.8.20` related to the `PUSH0` opcode on the Avalanche Fuji network.
- **Solution**: We are using Solidity version `0.8.19`. Ensure you use the OpenZeppelin contracts package version `^4.9.3`, which is compatible with this version of Solidity.
