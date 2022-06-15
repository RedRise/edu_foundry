//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Emitter {
    event Blip(uint256 indexed count, string message);

    uint256 counter;

    constructor() {
        counter = 0;
    }

    function TocToc(string memory message) public {
        emit Blip(counter, message);

        counter++;
    }
}
