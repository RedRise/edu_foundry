//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/console2.sol";

contract Greeter {
    string private greeting;

    constructor(string memory _greeting) {
        console2.log("Deploying a Greeter with greeting:", _greeting);
        greeting = _greeting;
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function setGreeting(string memory _greeting) public {
        console2.log(
            "Changing greeting from '%s' to '%s'",
            greeting,
            _greeting
        );
        greeting = _greeting;
    }
}
