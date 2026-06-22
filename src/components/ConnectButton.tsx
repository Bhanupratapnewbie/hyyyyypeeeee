import { useAccount, useConnect, useDisconnect } from 'wagmi';
import { isAdmin, shortAddress } from '../config/admin';

export function ConnectButton() {
  const { address, isConnected } = useAccount();
  const { connect, connectors, isPending } = useConnect();
  const { disconnect } = useDisconnect();

  if (isConnected && address) {
    return (
      <div className="connect">
        <span className="addr">
          {shortAddress(address)}
          {isAdmin(address) && <span className="badge">ADMIN</span>}
        </span>
        <button onClick={() => disconnect()}>Disconnect</button>
      </div>
    );
  }

  const injectedConnector = connectors[0];
  return (
    <button
      className="primary"
      disabled={isPending || !injectedConnector}
      onClick={() => injectedConnector && connect({ connector: injectedConnector })}
    >
      {isPending ? 'Connecting…' : 'Connect Wallet'}
    </button>
  );
}
