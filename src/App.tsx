import { BRAND } from './config/branding';
import { ADMIN_ADDRESS } from './config/admin';
import { ConnectButton } from './components/ConnectButton';
import { FundOverview } from './components/FundOverview';
import { Deposit } from './components/Deposit';

export default function App() {
  return (
    <div className="app">
      <header className="topbar">
        <div className="brand">
          <span className="logo">◎</span>
          <div>
            <strong>{BRAND.name}</strong>
            <span className="ver">{BRAND.version}</span>
          </div>
        </div>
        <ConnectButton />
      </header>

      <main>
        <section className="hero">
          <h1>{BRAND.name}</h1>
          <p className="tagline">{BRAND.tagline}</p>
          <p className="muted">{BRAND.description}</p>
        </section>

        <div className="grid">
          <FundOverview />
          <Deposit />
        </div>
      </main>

      <footer>
        <span>
          {BRAND.name} {BRAND.version} · admin {ADMIN_ADDRESS}
        </span>
      </footer>
    </div>
  );
}
