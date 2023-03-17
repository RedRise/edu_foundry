// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract DeleteTest is Test {
    uint256 data;
    uint256[] dataArray;

    function setUp() public {
        data = 7777;
        dataArray = new uint256[](2);
        dataArray[0] = data;
        dataArray[1] = 8888;
    }

    function testDeleteSetUp() public {
        assertEq(data, 7777);
        assertEq(dataArray.length, 2);
    }

    function testDeleteUint() public {
        uint256 x = data;
        delete x; // sets x to 0, does not affect data
        assertEq(data, 7777);

        x = data;
        delete data;
        assertEq(x, 7777);
    }

    function testDeleteDataArrayCascadeStorage() public {
        uint256[] storage yStorage = dataArray;
        delete dataArray; // this sets dataArray.length to zero, but as uint[] is a complex object, also
        assertEq(dataArray.length, 0);
        assertEq(yStorage.length, 0);
    }

    function testDeleteDataArrayNoCascadeMemory() public {
        uint256[] memory yMemory = dataArray;
        delete dataArray; // this sets dataArray.length to zero, but as uint[] is a complex object, also
        assertEq(dataArray.length, 0);
        assertEq(yMemory.length, 2);
    }

    function testDeleteMemoryReferenceArray() public {
        uint256[] memory yMemory = dataArray;
        delete yMemory; // this sets dataArray.length to zero, but as uint[] is a complex object, also
        assertEq(dataArray.length, 2);
        assertEq(yMemory.length, 0);
    }
}
