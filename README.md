# Foundry Smart Contract Defi Stablecoin F23

### Structure of our Project

1. Relative Stability: Anchored or Pegged => $1.00

- Chainlink Price Feed.
- Set a function to exchange ETH & BTC => $$$

2. Stability Mechanism (Minting): Algorithmic (Decentralized)

- People can only mint the stablecoin with enough collateral (code).

3. Collateral : Exogenous (Crypto)

- wETH
- wBTC

4. Calculate health function
5. Set health factor if 0
6. Added a bunch of view function

7. Deep drive in invriants/properties test
8. Test Chainlink Oracle we are using to get price feeds

## Quickstart

```
git clone https://github.com/SabeloMkhwanzi/6-foundry-smart-contract-defi-stablecoin-f23.git
cd 6-foundry-smart-contract-defi-stablecoin-f23
forge build
```

# Usage

Deploy:

```
forge script scripts/DeployFundMe.s.sol
```

## Testing

1. Unit

This repo we cover #1 and #3.

```
forge test
```

or

```
// Only run test functions matching the specified regex pattern.

"forge test -m testFunctionName" is deprecated. Please use

forge test --match-test testFunctionName
```

or

```
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file, similar to what you see in `.env.example`.

- `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)). **NOTE:** FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
  - You can [learn how to export it here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
- `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

1. Get testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH. You should see the ETH show up in your metamask.

3. Deploy

```
forge script script/DeployFundMe.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

# Thank you!
