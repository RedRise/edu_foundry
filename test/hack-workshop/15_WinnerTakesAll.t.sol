//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract WinnerTakesAllTest is Test {
    WinnerTakesAll game;
    address alice;
    address bob;

    function setUp() public {
        alice = address(7777);
        payable(alice).transfer(10 ether);

        bob = address(8888);
        payable(bob).transfer(10 ether);

        vm.prank(alice);
        game = new WinnerTakesAll();
    }

    function testOneRoundOnePlayer() public {
        game.createNewRounds(1);

        vm.startPrank(alice);
        game.setRewardsAtRound{value: 1 ether}(0);

        address[] memory recipients = new address[](1);
        recipients[0] = bob;

        game.setRewardsAtRoundfor(0, recipients);
        vm.stopPrank();

        assert(game.isAllowedAt(0, bob));
        assertEq(address(game).balance, 1 ether);

        vm.prank(bob);
        game.withdrawRewards(0);
        assertEq(bob.balance, 11 ether);

        // vm.startPrank(alice);
        // game.setRewardsAtRound{value: 1 ether}(0);
        // game.clearRounds();
    }

    function testGigaRounds() public {
        game.createNewRounds(100);
    }
}
