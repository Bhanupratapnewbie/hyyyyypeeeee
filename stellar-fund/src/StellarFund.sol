// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title StellarFund
/// @notice A minimal, self-contained decentralized fund vault for Hyperliquid (HyperEVM).
///         Depositors send the native asset (HYPE) and receive fund shares proportional to
///         their contribution to the fund's net assets. Shares are redeemable for the
///         underlying assets at the current exchange rate.
/// @dev Original implementation. No external dependencies. Not audited — use at your own risk.
contract StellarFund {
    /// @notice The primary / admin wallet for the fund (single source of truth).
    address public constant ADMIN_ADDRESS = 0x7241CD07ad0F2ADFEB3a627D5b83307925E48d6B;

    string public constant NAME = "STELLAR";
    string public constant SYMBOL = "STAR";

    /// @notice Current admin (initialized to ADMIN_ADDRESS, transferable by the admin).
    address public admin;

    /// @notice Total shares outstanding.
    uint256 public totalShares;

    /// @notice Shares held by each account.
    mapping(address => uint256) public sharesOf;

    event Deposit(address indexed account, uint256 assets, uint256 shares);
    event Withdraw(address indexed account, uint256 assets, uint256 shares);
    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);

    error ZeroAmount();
    error NotAdmin();
    error InsufficientShares();
    error TransferFailed();

    modifier onlyAdmin() {
        if (msg.sender != admin) revert NotAdmin();
        _;
    }

    constructor() {
        admin = ADMIN_ADDRESS;
    }

    /// @notice Total assets held by the fund (native balance).
    function totalAssets() public view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Preview how many shares a given asset amount would mint at the current rate.
    function previewDeposit(uint256 assets) public view returns (uint256) {
        uint256 supply = totalShares;
        uint256 held = totalAssets();
        if (supply == 0 || held == 0) return assets;
        return (assets * supply) / held;
    }

    /// @notice Preview how many assets a given share amount would redeem at the current rate.
    function previewRedeem(uint256 shares) public view returns (uint256) {
        uint256 supply = totalShares;
        if (supply == 0) return 0;
        return (shares * totalAssets()) / supply;
    }

    /// @notice Deposit native assets into the fund and receive shares.
    function deposit() external payable returns (uint256 shares) {
        uint256 assets = msg.value;
        if (assets == 0) revert ZeroAmount();

        uint256 supply = totalShares;
        // Balance already includes msg.value, so price against the pre-deposit balance.
        uint256 heldBefore = address(this).balance - assets;
        shares = (supply == 0 || heldBefore == 0) ? assets : (assets * supply) / heldBefore;

        sharesOf[msg.sender] += shares;
        totalShares = supply + shares;

        emit Deposit(msg.sender, assets, shares);
    }

    /// @notice Redeem shares for the underlying assets.
    function withdraw(uint256 shares) external returns (uint256 assets) {
        if (shares == 0) revert ZeroAmount();

        uint256 userShares = sharesOf[msg.sender];
        if (shares > userShares) revert InsufficientShares();

        assets = (shares * totalAssets()) / totalShares;

        // Checks-effects-interactions: update state before transferring.
        sharesOf[msg.sender] = userShares - shares;
        totalShares -= shares;

        (bool ok, ) = payable(msg.sender).call{value: assets}("");
        if (!ok) revert TransferFailed();

        emit Withdraw(msg.sender, assets, shares);
    }

    /// @notice Transfer admin rights to a new address.
    function transferAdmin(address newAdmin) external onlyAdmin {
        emit AdminTransferred(admin, newAdmin);
        admin = newAdmin;
    }
}
