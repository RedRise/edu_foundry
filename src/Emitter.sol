// UNLICENSED
pragma solidity ^0.8.13;

contract Emitter {
    
    event Blip(uint indexed count, string message);

    uint counter;

    constructor() {
        
        counter = 0;

    }

    function TocToc(string memory message) public { 
        
        emit Blip(counter, message);

        counter++;
    }

}