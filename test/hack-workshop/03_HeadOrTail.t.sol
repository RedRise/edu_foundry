//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/hack-workshop/03_HeadOrTail.sol";

contract HeadOrTailTest is Test {
    HeadOrTail game;
    address alice;
    address bob;

    function setUp() public {
        game = new HeadOrTail();
        payable(alice).transfer(1 ether);
        payable(bob).transfer(1 ether);
    }

    /// @notice Choice made by Alice is public, then visible by Bob... easy to guess
    function testGameAccessPublicPrevChoice() public {
        vm.prank(alice);
        game.choose{value: 1 ether}(true);

        assertEq(bob.balance, 10**18);
        bool prevChoice = game.lastChoiceHead();

        vm.prank(bob);
        game.guess{value: 1 ether}(prevChoice);
        assertEq(bob.balance, 2 ether);
    }
}
