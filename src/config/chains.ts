import { defineChain } from 'viem';

/** Hyperliquid EVM (HyperEVM) mainnet. */
export const hyperEvm = defineChain({
  id: 999,
  name: 'Hyperliquid',
  nativeCurrency: { name: 'Hype', symbol: 'HYPE', decimals: 18 },
  rpcUrls: {
    default: { http: ['https://rpc.hyperliquid.xyz/evm'] },
  },
  blockExplorers: {
    default: {
      name: 'Hyperliquid Explorer',
      url: 'https://app.hyperliquid.xyz/explorer',
    },
  },
});

/** Hyperliquid EVM (HyperEVM) testnet. */
export const hyperEvmTestnet = defineChain({
  id: 998,
  name: 'Hyperliquid Testnet',
  testnet: true,
  nativeCurrency: { name: 'Hype', symbol: 'HYPE', decimals: 18 },
  rpcUrls: {
    default: { http: ['https://rpc.hyperliquid-testnet.xyz/evm'] },
  },
  blockExplorers: {
    default: {
      name: 'Hyperliquid Testnet Explorer',
      url: 'https://app.hyperliquid-testnet.xyz/explorer',
    },
  },
});
