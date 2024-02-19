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

- `MNEMONIC_PHRASE`: Nft contract owner wallet mnemonic.
- `URL_PROVIDER`: The URL of the Avalanche network provider.
- `SNOWTRACE_API_KEY`: Your Snowtrace API key.


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
- **Function**: `mintToken(quantity)`
- **Description**: Allows users to mint new CoffToken tokens in exchange for ERC20 tokens. The minting process requires the user to pay the set price per token in ERC20
- **Usage**: `mintToken(<quantity>)`

### Redeeming Tokens
- **Function**: `redeemToken(uint16 quantity)`
- **Description**: Enables token holders to redeem their tokens for the original mint price in ERC20 tokens, then burns the NFTs
- **Usage**: `redeemToken(<quantity>)`

### Transfer Token
- **Function**: `transferToken(uint16 quantity, address newOwner)`
- **Description**: Allows token owners to transfer a specified quantity of CoffToken tokens to a new owner.
- **Usage**: `transferToken(<quantity>, <new_owner_address>)`

## Resources
- [Avalanche Truffle Documentation](https://la-url-aqui)
- [OpenZeppelin Contracts](https://la-otra-url-aqui)


## Known Issues and Solutions

### Solidity Version Compatibility
- **Issue**: A compatibility problem with Solidity version `0.8.20` related to the `PUSH0` opcode on the Avalanche Fuji network.
- **Solution**: We are using Solidity version `0.8.19`. Ensure you use the OpenZeppelin contracts package version `^4.9.3`, which is compatible with this version of Solidity.
