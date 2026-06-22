import { createConfig, http } from 'wagmi';
import { injected } from 'wagmi/connectors';
import { hyperEvm, hyperEvmTestnet } from './config/chains';

export const wagmiConfig = createConfig({
  chains: [hyperEvm, hyperEvmTestnet],
  connectors: [injected()],
  transports: {
    [hyperEvm.id]: http(),
    [hyperEvmTestnet.id]: http(),
  },
});

declare module 'wagmi' {
  interface Register {
    config: typeof wagmiConfig;
  }
}
