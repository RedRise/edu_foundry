// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "src/01_Store.sol";
import "src/01_StoreHack.sol";
import "forge-std/Test.sol";
import "forge-std/console2.sol";

contract StoreHackTest is Test {
    Store myStore;
    address myStoreAdr;
    StoreHack myStoreHack;
    address myStoreHackAdr;
    address alice;

    function setUp() public {
        myStore = new Store();
        myStoreAdr = address(myStore);
        myStoreHack = new StoreHack(myStoreAdr);
        myStoreHackAdr = address(myStoreHack);
        alice = address(7777);
    }

    function testTransferToAlice() public {
        uint256 amount = 1000000;
        payable(alice).transfer(amount);
        assertEq(alice.balance, amount);
    }

    function testCallValueToAlice() public {
        uint256 amount = 1000000;
        (bool success, ) = alice.call{value: amount}("");
        console2.log("Transfer success", success);
        assertEq(alice.balance, amount);
    }

    function testTransferToContract() public {
        uint256 amount = 1000000;
        payable(myStoreHackAdr).transfer(amount);
        assertEq(myStoreHackAdr.balance, amount);
    }

    function testCallValueToContract() public {
        uint256 amount = 1000000;
        (bool success, ) = myStoreHackAdr.call{value: amount}("");
        console2.log("Transfer success", success);
        assertEq(myStoreHackAdr.balance, amount);
    }

    function testStoreHackStoreAndTake() public {
        uint256 amount = 1000000000000;
        // payable(myStoreHackAdr).transfer(amount);

        vm.deal(myStoreHackAdr, amount);

        console.log("myStoreHack address", myStoreHackAdr);
        console.log("myStoreHack initial balance", myStoreHackAdr.balance);

        myStoreHack.call_store(amount / 2);
        console.log("myStoreHack balance", myStoreHackAdr.balance);

        vm.expectRevert();
        myStoreHack.call_take();
        console.log("myStoreHack balance", myStoreHackAdr.balance);

        (, uint256 samount) = myStore.safes(0);
        console.log("Store amount", samount);

        assert(true);
    }
}
