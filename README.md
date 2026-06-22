# GROWI HF

**A decentralized fund on Hyperliquid.** `v19`

GROWI HF is a community-governed, decentralized fund running on the Hyperliquid
EVM (HyperEVM). Deposits, treasury and administration are anchored to a single
transparent **admin / primary wallet**.

## Admin / primary address

The fund's admin address is the single source of truth across the whole app and
is defined in [`src/config/admin.ts`](src/config/admin.ts):

```
0x7241cd07ad0f2adfeb3a627d5b83307925e48d6b
```

Everything (treasury display, deposit target, admin checks, footer) references
this constant.

## Stack

- Vite + React 18 + TypeScript
- wagmi + viem for wallet connection and on-chain reads/writes
- HyperEVM mainnet (chainId `999`) and testnet (chainId `998`) — see
  [`src/config/chains.ts`](src/config/chains.ts)

## Getting started

```bash
npm install
npm run dev        # start the dev server on http://localhost:5173
npm run build      # type-check + production build
npm run preview    # preview the production build
npm run lint       # eslint
npm run typecheck  # tsc --noEmit
```

## Project layout

```
src/
  config/
    admin.ts      # ADMIN_ADDRESS (the primary wallet) + helpers
    branding.ts   # GROWI HF name / tagline / version
    chains.ts     # HyperEVM mainnet + testnet definitions
  components/
    ConnectButton.tsx  # connect/disconnect + ADMIN badge
    FundOverview.tsx   # treasury balance for the admin address
    Deposit.tsx        # send HYPE to the admin address
  App.tsx
  main.tsx
```

## Notes

- Wallet connection uses the injected connector (e.g. MetaMask). Add your
  browser wallet and the HyperEVM network to interact.
- Make sure the admin address above is one you control before deploying — it is
  embedded as the fund's administrator and deposit target.
