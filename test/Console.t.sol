// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract ConsoleTest is Test {

    function testConsoleUintLog() public view {
        uint testVar = 256;
        console.log(testVar);
    }

    function testConsoleUintLogUint() public view {
        uint testVar = 256;
        console.logUint(testVar);
    }

    // // Error because console.log(int p0) seems to be missing
    // function testConsoleIntLog() public view {
    //     int testVar = -256;
    //     console.log(testVar);
    // }

    function testConsoleIntLogInt() public view {
        int testVar = -256;
        console.logInt(testVar);
    }

    // // Error because console.log(int256 p0) seems to be missing
    // function testConsoleInt256Log() public view {
    //     int256 testVar = -256;
    //     console.log(testVar);
    // }

    function testConsoleInt256LogInt() public view {
        int256 testVar = -256;
        console.logInt(testVar);
    }

    
}
