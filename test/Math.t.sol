// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract MathTest is Test {
    function setUp() public {}

    function testIncrementPlusPlus() public view {
        uint256 i;

        for (i; i < 4; ++i) {
            console.log(i);
        }

        assert(true);
    }

    function testDiv() public view {
        uint256 i = 1;

        for (i = 1; i < 10; ++i) {
            console.log((1 ether / i) * i);
        }

        assert(true);
    }

    function testAbiEncode() public view {
        uint256 i;

        for (i = 0; i < 100; ++i) {
            console.logBytes32(keccak256(abi.encode(false, i)));
        }

        assert(true);
    }

    function testUintSubstractionUnderFlow() public {
        uint256 i = 10;
        i -= 15;
        assertGt(i, 0);
    }
}
