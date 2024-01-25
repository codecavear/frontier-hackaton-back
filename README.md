# Frontier Hackathon Backend

This project is focused on deploying a smart contract to the Avalanche Fuji Network using Truffle.

### Prerequisites Verification

Before beginning the migration process, ensure that your project setup is complete:

- `contracts/` directory: Contains Solidity contracts.
- `migrations/` directory: Contains migration scripts.
- `truffle-config.js`: Configures network settings.

### Configuration

#### Environment Variables

- **Secure Storage**: Create a `.env` file to securely store your mnemonic.
  ```plaintext
  MNEMONIC='your_mnemonic_here'
    ```

## Migration

    Run the migration command targeting the Fuji network:
    ```
    truffle migrate --network fuji
    ```

## Confirm Deployment

    Check the terminal output to confirm that your contracts have been deployed. It should include the deployed contract addresses.

## Post-Migration

    You can verify the deployment of your contract on an Avalanche block explorer by searching for the deployed contract addresses.

## NOtes
- Some contracts doestn live in zeppeling last version use: https://docs.openzeppelin.com/contracts/2.x/api/drafts