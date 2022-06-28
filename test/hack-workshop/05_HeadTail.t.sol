//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/hack-workshop/05_HeadTail.sol";

contract HeadTailTest is Test {
    HeadTail game;
    address alice;
    address bob;
    bool chooseHead = true;
    uint256 number = 1111;

    function setUp() public {
        alice = address(7777);
        bob = address(8888);

        payable(alice).transfer(2 ether);

        vm.prank(alice);
        game = new HeadTail{value: 1 ether}(
            keccak256(abi.encode(chooseHead, number))
        );
        console.logBytes32(game.commitmentA());
        // vm.prank(bob);
        // game.guess{value: 1 ether}(chooseHead);
    }

    function testHeadTailChildSelfDestruct() public {
        assertEq(address(game).balance, 1 ether);
        console.log("Alice balance", address(alice).balance);
        assertEq(game.partyA(), payable(alice));
        assertEq(alice.balance, 1 ether);

        HeadTailHack hack;
        hack = HeadTailHack(address(game));
        hack.close();
        console.log("Game balance", address(game).balance);
    }

    function testModifyPartyBFromChild() public {
        HeadTailChild child = HeadTailChild(address(game));
        console.log("PartyB", game.partyB());

        child.updateAddressB(bob);
        console.log("PartyB", game.partyB());
    }
}
