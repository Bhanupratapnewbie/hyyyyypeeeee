import { useBalance } from 'wagmi';
import { ADMIN_ADDRESS, shortAddress } from '../config/admin';
import { hyperEvm } from '../config/chains';

export function FundOverview() {
  const { data, isLoading } = useBalance({
    address: ADMIN_ADDRESS,
    chainId: hyperEvm.id,
  });

  return (
    <section className="card">
      <h2>Fund Treasury</h2>
      <p className="muted">
        All GROWI HF activity is anchored to the admin / primary wallet below.
      </p>
      <dl className="kv">
        <div>
          <dt>Admin address</dt>
          <dd>
            <code>{ADMIN_ADDRESS}</code>
          </dd>
        </div>
        <div>
          <dt>Network</dt>
          <dd>{hyperEvm.name} (chainId {hyperEvm.id})</dd>
        </div>
        <div>
          <dt>Treasury balance</dt>
          <dd>
            {isLoading
              ? 'Loading…'
              : data
                ? `${Number(data.formatted).toFixed(4)} ${data.symbol}`
                : '—'}
          </dd>
        </div>
      </dl>
      <a
        className="link"
        href={`${hyperEvm.blockExplorers.default.url}/address/${ADMIN_ADDRESS}`}
        target="_blank"
        rel="noreferrer"
      >
        View {shortAddress()} on explorer ↗
      </a>
    </section>
  );
}
