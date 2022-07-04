//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract GuessTheAverageTest is Test {
    address alice;
    bytes32 aliceBlind;
    address bob;
    bytes32 bobBlind;
    address edgar;
    bytes32 edgarBlind;
    GuessTheAverage game;

    function setUp() public {
        alice = address(7777);
        payable(alice).transfer(2 ether);
        aliceBlind = keccak256(abi.encode(alice));

        bob = address(8888);
        payable(bob).transfer(2 ether);
        bobBlind = keccak256(abi.encode(bob));

        edgar = address(9999);
        payable(edgar).transfer(2 ether);
        edgarBlind = keccak256(abi.encode(edgar));

        game = new GuessTheAverage(2 days, 2 days);
    }

    function guessesAliceBobEdgar() internal {
        bytes32 aliceCommit = keccak256(abi.encode(alice, 20, aliceBlind));
        vm.prank(alice);
        game.guess{value: 1 ether}(aliceCommit);

        bytes32 bobCommit = keccak256(abi.encode(bob, 21, bobBlind));
        vm.prank(bob);
        game.guess{value: 1 ether}(bobCommit);

        bytes32 edgarCommit = keccak256(abi.encode(edgar, 100, edgarBlind));
        vm.prank(edgar);
        game.guess{value: 1 ether}(edgarCommit);
    }

    function testCantRevealBefore() public {
        guessesAliceBobEdgar();

        vm.prank(alice);

        vm.expectRevert("Reveal period must have begun and not ended");
        game.reveal(20, aliceBlind);
    }

    function testCanGuessAfterCommitmentPeriod() public {
        bytes32 aliceCommit = keccak256(abi.encode(alice, 20, aliceBlind));
        vm.warp(block.timestamp + 2.5 days);
        vm.prank(alice);
        vm.expectRevert("Commit period must have begun and not ended");
        game.guess{value: 1 ether}(aliceCommit);
    }

    function testNormalReveal() public {
        guessesAliceBobEdgar();

        vm.warp(block.timestamp + 3 days);

        vm.prank(alice);
        game.reveal(20, aliceBlind);
        assertEq(game.average(), 20);
        console.log("guesses[0]", game.guesses(0));

        vm.prank(bob);
        game.reveal(21, bobBlind);
        console.log("guesses[1]", game.guesses(1));
        assertEq(game.average(), 41);

        vm.prank(edgar);
        game.reveal(100, edgarBlind);
        assertEq(game.average(), 141);
        console.log("guesses[2]", game.guesses(2));

        vm.warp(block.timestamp + 2 days);
        console.log("Stage before findWinners:", uint256(game.currentStage()));
        game.findWinners(2);
        console.log("Stage after 2 findWinners:", uint256(game.currentStage()));
        // game.findWinners(1);
        // console.log("Stage after findWinners:", uint256(game.currentStage()));
        console.log(game.average());
        console.log("Number of losers:", game.numberOfLosers());
        for (uint256 i = 0; i < 2; ++i) {
            console.log("winner", game.winners(i));
        }

        game.distribute(0);
        console.log("alice balance:", alice.balance);
        console.log("bob balance:", bob.balance);
    }
}
