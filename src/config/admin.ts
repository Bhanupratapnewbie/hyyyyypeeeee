/**
 * Central configuration for the GROWI HF admin / primary wallet.
 *
 * This address is the single source of truth for the fund's administrator.
 * It is referenced everywhere in the app (treasury display, deposit target,
 * access checks, etc.) via the exported constant below.
 */
import { getAddress, type Address } from 'viem';

// Primary / admin wallet address for GROWI HF.
export const ADMIN_ADDRESS: Address = getAddress(
  '0x7241cd07ad0f2adfeb3a627d5b83307925e48d6b',
);

// Alias kept for readability at call sites that talk about the "primary" wallet.
export const PRIMARY_ADDRESS: Address = ADMIN_ADDRESS;

/** Returns true if the given address is the GROWI HF admin address. */
export function isAdmin(address?: string | null): boolean {
  if (!address) return false;
  try {
    return getAddress(address) === ADMIN_ADDRESS;
  } catch {
    return false;
  }
}

/** Shortened form, e.g. 0x7241…d6b, for compact UI display. */
export function shortAddress(address: string = ADMIN_ADDRESS): string {
  return `${address.slice(0, 6)}…${address.slice(-4)}`;
}
