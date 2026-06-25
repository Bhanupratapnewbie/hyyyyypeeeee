// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {StellarFund} from "../src/StellarFund.sol";

contract StellarFundTest is Test {
    StellarFund fund;

    address alice = address(0xA11CE);
    address bob = address(0xB0B);

    function setUp() public {
        fund = new StellarFund();
        vm.deal(alice, 100 ether);
        vm.deal(bob, 100 ether);
    }

    function test_AdminIsPrimaryAddress() public view {
        assertEq(fund.admin(), fund.ADMIN_ADDRESS());
        assertEq(fund.ADMIN_ADDRESS(), 0x7241CD07ad0F2ADFEB3a627D5b83307925E48d6B);
    }

    function test_FirstDepositMintsOneToOne() public {
        vm.prank(alice);
        uint256 shares = fund.deposit{value: 10 ether}();
        assertEq(shares, 10 ether);
        assertEq(fund.sharesOf(alice), 10 ether);
        assertEq(fund.totalShares(), 10 ether);
        assertEq(fund.totalAssets(), 10 ether);
    }

    function test_SecondDepositSharesProRata() public {
        vm.prank(alice);
        fund.deposit{value: 10 ether}();

        vm.prank(bob);
        uint256 bobShares = fund.deposit{value: 5 ether}();

        assertEq(bobShares, 5 ether);
        assertEq(fund.totalShares(), 15 ether);
        assertEq(fund.totalAssets(), 15 ether);
    }

    function test_WithdrawRedeemsAssets() public {
        vm.prank(alice);
        fund.deposit{value: 10 ether}();

        uint256 before = alice.balance;
        vm.prank(alice);
        uint256 assets = fund.withdraw(4 ether);

        assertEq(assets, 4 ether);
        assertEq(alice.balance, before + 4 ether);
        assertEq(fund.sharesOf(alice), 6 ether);
    }

    function test_RevertWhen_DepositZero() public {
        vm.prank(alice);
        vm.expectRevert(StellarFund.ZeroAmount.selector);
        fund.deposit{value: 0}();
    }

    function test_RevertWhen_WithdrawMoreThanOwned() public {
        vm.prank(alice);
        fund.deposit{value: 1 ether}();
        vm.prank(alice);
        vm.expectRevert(StellarFund.InsufficientShares.selector);
        fund.withdraw(2 ether);
    }

    function test_RevertWhen_NonAdminTransfersAdmin() public {
        vm.prank(alice);
        vm.expectRevert(StellarFund.NotAdmin.selector);
        fund.transferAdmin(alice);
    }

    function test_AdminCanTransfer() public {
        vm.prank(fund.ADMIN_ADDRESS());
        fund.transferAdmin(bob);
        assertEq(fund.admin(), bob);
    }
}
