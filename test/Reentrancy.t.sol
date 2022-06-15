// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Reentrancy.sol";

contract ReentrancyTest is Test {
    VulnerableVault vault;
    address vaultAdr;
    address alice;

    function setUp() public {
        vault = new VulnerableVault();
        vaultAdr = address(vault);
        alice = address(7777);
    }

    function testDepositWithdrawByHand() public {
        vm.deal(alice, 1 ether);
        vm.startPrank(alice);

        vault.deposit{value: 123}();
        assertEq(vaultAdr.balance, 123);

        vault.withdrawTransfer();
        assertEq(vaultAdr.balance, 0);

        // console.log("Alice final balance", alice.balance);
    }

    function testReentrancyTransfer() public {
        MaliciousTransfer mali;
        mali = new MaliciousTransfer();
        address maliAdr = address(mali);

        uint256 amount = 1000000000;
        // payable(maliAdr).transfer(amount);
        vm.deal(maliAdr, amount);
        assertEq(maliAdr.balance, amount);

        mali.call_deposit(vaultAdr, amount / 2);
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2);

        vm.expectRevert();
        mali.call_withdraw();

        console.log("Final malicious balance:", maliAdr.balance);
    }

    function testReentrancySend() public {
        MaliciousSend mali;
        mali = new MaliciousSend();
        address maliAdr = address(mali);

        uint256 amount = 1000000000;
        // payable(maliAdr).transfer(amount);
        vm.deal(maliAdr, amount);
        assertEq(maliAdr.balance, amount);

        mali.call_deposit(vaultAdr, amount / 2);
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2);

        mali.call_withdraw();

        console.log("Final malicious balance:", maliAdr.balance);
    }

    function testReentrancyCall() public {
        MaliciousCall mali;
        mali = new MaliciousCall();
        address maliAdr = address(mali);

        uint256 amount = 1000000000;
        // payable(maliAdr).transfer(amount);
        vm.deal(maliAdr, amount);
        assertEq(maliAdr.balance, amount);

        mali.call_deposit(vaultAdr, amount / 2);
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2);

        mali.call_withdraw();

        console.log("Final malicious balance", maliAdr.balance);
        console.log("Final Vault balance", vaultAdr.balance);
    }
}
