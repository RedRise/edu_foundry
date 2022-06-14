// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract ConsoleTest is Test {
    // event log_int(int256 p0);

    function testConsoleUintLog() public view {
        uint256 testVar = 256;
        console.log(testVar);
    }

    function testConsoleUintLogUint() public view {
        uint256 testVar = 256;

        // vm.expectEmit(false, false, false, false);
        // emit log_uint(testVar);

        console.logUint(testVar);
    }

    // // Error because console.log(int p0) seems to be missing
    // function testConsoleIntLog() public view {
    //     int testVar = -256;
    //     console.log(testVar);
    // }

    function testConsoleIntLogInt() public view {
        int256 testVar = -256;
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
