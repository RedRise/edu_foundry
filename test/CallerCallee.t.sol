// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/CallerCallee.sol";

contract CallerCalleeTest is Test {
    function testCallerBasic() public {
        InfoFeed feed = new InfoFeed();

        Consumer cons = new Consumer();

        cons.setFeed(feed);

        uint256 result;

        result = cons.callFeed();

        assertEq(result, 42);

        // // allowed even withou receive function implemented
        // vm.deal(address(cons), 1 ether);
        payable(address(cons)).transfer(1000000000);

        result = cons.callPays10();
        assertEq(result, 10);

        result = cons.callPays(11);
        assertEq(result, 11);

        // final feed contract should have 10+11 balance
        assertEq(address(feed).balance, 21);
    }
}
