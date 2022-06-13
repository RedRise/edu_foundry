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
}
