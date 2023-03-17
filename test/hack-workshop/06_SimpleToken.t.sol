//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract SimpleTokenTest is Test {
    SimpleToken stoken;
    address alice;
    address bob;
    address edgar;

    function setUp() public {
        alice = address(7777);
        bob = address(8888);
        edgar = address(9999);

        vm.prank(alice);
        stoken = new SimpleToken();
    }

    function testSimpleTokenNoLimit() public {
        vm.startPrank(alice);
        stoken.sendToken(bob, 1000e18);
        assertEq(stoken.balances(bob), 1000e18);
        assertEq(stoken.balances(alice), 0);

        stoken.sendToken(edgar, 1);
        assertEq(stoken.balances(edgar), 1);
    }
}
