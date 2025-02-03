## Smart Contracts

The project includes an ERC20 token contract with the following features:

#### Features
- **Role-Based Access Control**: Implements OpenZeppelin's AccessControlDefaultAdminRules
  - `DEFAULT_ADMIN_ROLE`: Can enable transfers and manage other roles
  - `MINTER_ROLE`: Can mint new tokens
  - `TRANSFER_ROLE`: Can transfer tokens before transfers are enabled

- **Controlled Token Transfers**: 
  - Transfers are initially disabled
  - Only addresses with `TRANSFER_ROLE`, the owner, or minting operations can transfer tokens when transfers are disabled
  - Transfers can be enabled by admin (one-way operation - cannot be disabled once enabled)

- **Token Minting**:
  - Controlled minting through `MINTER_ROLE`
  - No maximum supply cap

#### Inheritance
- OpenZeppelin's ERC20
- OpenZeppelin's ERC20Burnable
- OpenZeppelin's AccessControlDefaultAdminRules

#### Key Functions
- `mint(address to, uint256 amount)`: Allows `MINTER_ROLE` to mint new tokens
- `enableTransfers()`: Allows admin to enable transfers for all holders
- `burn(uint256 amount)`: Allows token holders to burn their tokens (inherited from ERC20Burnable)

#### Security Features
- Role-based access control for critical functions
- Protected transfer functionality until explicitly enabled
- Default admin rules for secure role management

#### Code Coverage
The smart contracts have been thoroughly tested with 100% coverage across all metrics:
- **Lines**: 100% (8/8 lines)
- **Statements**: 100% (5/5 statements)
- **Branches**: 100% (3/3 branches)
- **Functions**: 100% (3/3 functions)

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
