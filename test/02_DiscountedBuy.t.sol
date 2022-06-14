// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "src/02_DiscountedBuy.sol";

contract DiscountedBuyTest is Test {
    DiscountedBuy discount;
    address alice;

    function setUp() public {
        discount = new DiscountedBuy();
        alice = address(7777);
    }

    function testDiscountedBuy() public {
        vm.deal(alice, 2 ether);
        vm.startPrank(alice);

        uint256 price = discount.price();
        discount.buy{value: price / 2}();

        assertEq(discount.objectBought(alice), 1);
    }
}
