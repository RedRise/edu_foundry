// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract DiscountedBuyTest is Test {
    DiscountedBuy discount;
    address alice;

    function setUp() public {
        discount = new DiscountedBuy();
        alice = address(7777);
    }

    function testDiscountedBuy() public {
        vm.deal(alice, 4 ether);
        vm.startPrank(alice);

        uint256 price;

        // First Buy, price = 1 ether OK
        price = discount.price();
        discount.buy{value: price}();
        assertEq(discount.objectBought(alice), 1);

        // Second Buy, price = 0.5 ether OK
        price = discount.price();
        discount.buy{value: price}();
        assertEq(discount.objectBought(alice), 2);

        // Third Buy, price = 1/3 ether FAIL (internal require not consistent)
        price = discount.price();
        vm.expectRevert();
        discount.buy{value: price}();
        assertEq(discount.objectBought(alice), 2);
    }
}
