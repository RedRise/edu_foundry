// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "src/01_Store.sol";

contract Storetest is Test {
    Store myStore;

    function setUp() public {
        myStore = new Store();
    }

    function testStore33Wei() public {
        address adr = address(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
        uint256 balance;
        uint256 amount;

        balance = adr.balance;
        myStore.store{value: 33 wei}();

        (adr, amount) = myStore.safes(0);

        assertEq(amount, 33);
        assertEq(balance - adr.balance, 33);
    }

    function testStoreAllBalance() public {
        address adr = address(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
        console.log(adr.balance);

        uint256 amount = adr.balance;
        myStore.store{value: amount}();

        (adr, amount) = myStore.safes(0);
        console.log(adr.balance);

        assertEq(amount, 33);
    }
}
