//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract SnapShotTokenTest is Test {
    SnapShotToken tokens;
    address alice;

    // address bob;

    function setUp() public {
        alice = address(7777);
        payable(alice).transfer(10 ether);
        tokens = new SnapShotToken();
    }

    function testSimpleBuy() public {
        vm.prank(alice);
        tokens.buyToken{value: 1 ether}();
        assertEq(alice.balance, 9 ether);
        assertEq(tokens.balances(alice), 1);
    }

    function testLosingEthIfNoFullBuy() public {
        vm.startPrank(alice);
        tokens.buyToken{value: 0.5 ether}();
        assertEq(alice.balance, 9.5 ether);
        assertEq(tokens.balances(alice), 0);
    }
}
