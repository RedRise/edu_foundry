//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract CommonCoffersTest is Test {
    CommonCoffers bank;
    address alice;
    address bob;

    function setUp() public {
        alice = address(7777);
        payable(alice).transfer(10 ether);
        bob = address(8888);
        payable(bob).transfer(10 ether);
        bank = new CommonCoffers();
    }

    function testWithdrawNaked() public {
        vm.prank(alice);
        bank.deposit{value: 10}(alice);
        // assertEq(alice.balance, 10 ether);
        // assertEq(bank.coffers(alice), 100);
        // assertEq(address(bank).balance, 0);

        vm.prank(bob);
        bank.deposit{value: 1000}(bob);
        // assertEq(bob.balance, 9 ether);

        vm.prank(alice);
        bank.withdraw(100);
    }
}
