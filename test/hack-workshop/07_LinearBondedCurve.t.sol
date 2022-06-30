//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract LinearBondedCurveTest is Test {
    LinearBondedCurve tokens;
    address alice;
    address bob;

    function setUp() public {
        alice = address(7777);
        payable(alice).transfer(10 ether);
        bob = address(8888);
        payable(bob).transfer(10 ether);
        tokens = new LinearBondedCurve();
    }

    function testPositiveBuySellLoop() public {
        vm.prank(alice);
        tokens.buy{value: 1e18}();
        assertEq(tokens.balances(alice), 1e18);

        // Show that simple buy then sell increase initial wealth
        uint256 initialWealth = bob.balance;
        vm.startPrank(bob);
        tokens.buy{value: 1e18}();
        assertEq(tokens.balances(bob), 5e17);

        tokens.sell(5e17);
        assertEq(tokens.balances(bob), 0);
        assertGt(bob.balance, initialWealth);
    }
}
