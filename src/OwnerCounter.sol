// UNLICENSED
pragma solidity ^0.8.13;


error UnAuthorized();

contract OwnerCounter {

    address public immutable owner;
    uint256 public count;

    constructor() {
        owner = msg.sender;
        count = 0;
    }

    function increment() external {
        if (msg.sender != owner){
            revert UnAuthorized();
        }

        count++;
    }

}