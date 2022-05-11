// UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/OwnerCounter.sol";

contract OwnerCounterTest is Test {

    OwnerCounter ownerCounter;

    function setUp() public {
        ownerCounter = new OwnerCounter();
    }   

    function testOwnerSingleIncrement() public {
        ownerCounter.increment();
        assertEq(ownerCounter.count(), 1);
    }

    function testOwnerTripleIncrements() public {
        ownerCounter.increment();
        assertEq(ownerCounter.count(), 1);

        ownerCounter.increment();
        assertEq(ownerCounter.count(), 2);

        ownerCounter.increment();
        assertEq(ownerCounter.count(), 3);

    }

    function testFailIncrementNoOwner() public {
        vm.prank(address(0));
        ownerCounter.increment();
    }

    // this test succeeds, with expected error message
    function testIncrementNoOwnerNotAuthorized() public {
        vm.expectRevert(UnAuthorized.selector);
        vm.prank(address(0));
        ownerCounter.increment();
    }

}