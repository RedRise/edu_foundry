// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract ContractBTest is Test {
    uint testNumber;

    function setUp() public {
        testNumber = 42;
    }

    function testNumberIs42() public {
        assertEq(testNumber, 42);
    }

    function testFailSubstruct43() public {
        testNumber -= 43;
    }
}
