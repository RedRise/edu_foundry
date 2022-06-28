// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/LibraryBasics.sol";

contract LibraryBasicsTest is Test {
    uint256[] array;

    function setUp() public {
        array = new uint256[](4);
        array[0] = 1;
        array[1] = 2;
        array[2] = 4;
        array[3] = 3;
    }

    function testIndexOfUintArray() public {
        uint256 index;
        (, index) = CustomUintArray.indexOf(array, 3);
        assertEq(index, 3);
    }

    function testContractUsingLibrary() public {
        uint256 index;
        ContractUsingLibrary con = new ContractUsingLibrary();
        (, index) = con.getIndexOf(array, 1);
        assertEq(index, 0);
    }
}
