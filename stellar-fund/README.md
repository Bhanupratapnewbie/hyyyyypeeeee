# STELLAR

A minimal, original **decentralized fund on Hyperliquid (HyperEVM)**.

This is a clean-room implementation — it does not reuse or derive from any third-party
protocol code. It is MIT licensed.

## Overview

`StellarFund` is a simple share-based vault for the native asset (HYPE):

- **Deposit** native assets and receive fund shares proportional to your contribution to the
  fund's net assets.
- **Withdraw** by redeeming shares for the underlying assets at the current exchange rate.
- **Admin** is anchored to a single primary wallet and is transferable by the current admin.

Admin / primary address (single source of truth): `0x7241CD07ad0F2ADFEB3a627D5b83307925E48d6B`

## Contract

`src/StellarFund.sol`

| Function | Description |
| --- | --- |
| `deposit()` payable | Deposit native assets, mint shares. |
| `withdraw(uint256 shares)` | Redeem shares for assets. |
| `previewDeposit(uint256)` / `previewRedeem(uint256)` | Quote shares/assets at the current rate. |
| `totalAssets()` / `totalShares()` | Fund accounting. |
| `transferAdmin(address)` | Admin-only; rotate the admin address. |

## Develop

Built with [Foundry](https://book.getfoundry.sh/).

```bash
forge install foundry-rs/forge-std   # provides the test harness
forge build
forge test
```

## Disclaimer

This code is a scaffold and has **not been audited**. Do not use it with real funds without a
thorough security review. Notably, simple share-vaults can be subject to first-depositor share
inflation; add a minimum-liquidity or virtual-shares mitigation before production use.
