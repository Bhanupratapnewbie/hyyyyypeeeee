import { useState } from 'react';
import { parseEther } from 'viem';
import { useAccount, useSendTransaction } from 'wagmi';
import { ADMIN_ADDRESS } from '../config/admin';

export function Deposit() {
  const { isConnected } = useAccount();
  const [amount, setAmount] = useState('');
  const { sendTransaction, isPending, data: hash, error } = useSendTransaction();

  function onDeposit() {
    if (!amount) return;
    sendTransaction({ to: ADMIN_ADDRESS, value: parseEther(amount) });
  }

  return (
    <section className="card">
      <h2>Deposit into the fund</h2>
      <p className="muted">
        Deposits are sent directly to the GROWI HF admin / primary wallet.
      </p>
      <div className="row">
        <input
          type="number"
          min="0"
          step="0.0001"
          placeholder="Amount (HYPE)"
          value={amount}
          onChange={(e) => setAmount(e.target.value)}
        />
        <button
          className="primary"
          disabled={!isConnected || isPending || !amount}
          onClick={onDeposit}
        >
          {isPending ? 'Confirming…' : 'Deposit'}
        </button>
      </div>
      {!isConnected && <p className="muted">Connect a wallet to deposit.</p>}
      {hash && (
        <p className="ok">
          Submitted: <code>{hash}</code>
        </p>
      )}
      {error && <p className="err">{error.message}</p>}
    </section>
  );
}
