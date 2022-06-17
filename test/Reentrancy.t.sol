// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Reentrancy.sol";

/// @title A title that should describe the contract/interface
/// @notice This contract tests Reentrancy depending on the way funds are withrawn by the vault.
//          1. transfer  : payable(msg.sender).transfer(amount);                    => revert
//          2. send      : bool success = payable(msg.sender).send(amount);         => no revert, but no transfer
//          3. call      : (bool success, ) = msg.sender.call{value: amount}("");   => vault hack
/// @dev Explain to a developer any extra details
contract ReentrancyTest is Test {
    VulnerableVault vault;
    address vaultAdr;
    address alice;
    address bob;
    uint256 usersBalance;

    function setUp() public {
        vault = new VulnerableVault();
        vaultAdr = address(vault);
        alice = address(7777);
        bob = address(8888);

        usersBalance = 10**10;

        vm.deal(alice, usersBalance);
        vm.deal(bob, usersBalance);

        vm.prank(alice);
        vault.deposit{value: usersBalance / 2}();

        vm.prank(bob);
        vault.deposit{value: usersBalance / 2}();
    }

    function testAliceDepositAndWithdrawByHand() public {
        assertEq(vaultAdr.balance, usersBalance);

        vm.prank(alice);
        vault.withdrawTransfer();
        assertEq(alice.balance, usersBalance);
    }

    function testReentrancyTransferRevertAndNoWithdraw() public {
        MaliciousTransfer mali = new MaliciousTransfer();
        address maliAdr = address(mali);

        uint256 amount = usersBalance;
        // payable(maliAdr).transfer(amount);
        vm.deal(maliAdr, amount);
        assertEq(maliAdr.balance, amount);

        mali.call_deposit(vaultAdr, amount / 2);
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2 + usersBalance);

        vm.expectRevert();
        mali.call_withdraw();
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2 + usersBalance);
    }

    function testReentrancySendNoRevertButNoWithdraw() public {
        MaliciousSend mali = new MaliciousSend();
        address maliAdr = address(mali);

        uint256 amount = usersBalance;
        // payable(maliAdr).transfer(amount);
        vm.deal(maliAdr, amount);
        assertEq(maliAdr.balance, amount);

        mali.call_deposit(vaultAdr, amount / 2);
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2 + usersBalance);

        mali.call_withdraw();
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2 + usersBalance);
    }

    function testReentrancyCallHackVault() public {
        MaliciousCall mali = new MaliciousCall();
        address maliAdr = address(mali);

        uint256 amount = usersBalance;
        // payable(maliAdr).transfer(amount);
        vm.deal(maliAdr, amount);
        assertEq(maliAdr.balance, amount);

        mali.call_deposit(vaultAdr, amount / 2);
        assertEq(maliAdr.balance, amount / 2);
        assertEq(vaultAdr.balance, amount / 2 + usersBalance);

        mali.call_withdraw();
        assertEq(maliAdr.balance, 2 * amount);
    }
}
