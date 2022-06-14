// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "src/01_Store.sol";

// https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/

contract Storetest is Test {
    struct SafeLoc {
        address owner;
        uint256 amount;
    }

    Store myStore;
    address initAdr;
    address user;

    function setUp() public {
        myStore = new Store();
        initAdr = address(0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84);
        user = address(7777);
    }

    function testStore33Wei() public {
        uint256 balance = initAdr.balance;
        myStore.store{value: 33 wei}();

        address adr;
        uint256 amount;
        (adr, amount) = myStore.safes(0);

        assertEq(adr, initAdr);
        assertEq(amount, 33);
        assertEq(balance - adr.balance, 33);
    }

    function testStoreAllBalance() public {
        uint256 balance = initAdr.balance;
        myStore.store{value: balance}();
        assertEq(initAdr.balance, 0);

        address adr;
        uint256 amount;
        (adr, amount) = myStore.safes(0);
        assertEq(adr, initAdr);
        assertEq(amount, balance);
    }

    function testStoreThenTake() public {
        payable(user).transfer(1234);

        vm.prank(user);
        myStore.store{value: 34}();
        assertEq(user.balance, 1200);

        address adr;
        uint256 amount;
        (adr, amount) = myStore.safes(0);
        assertEq(adr, user);
        assertEq(amount, 34);

        vm.prank(user);
        myStore.take();
        assertEq(user.balance, 1234);
        (adr, amount) = myStore.safes(0);
        assertEq(amount, 0);
    }

    function testStoreMultThenTake() public {
        payable(user).transfer(10000 wei);

        vm.startPrank(user);
        myStore.store{value: 1}();
        myStore.store{value: 2}();
        myStore.store{value: 3}();
        myStore.store{value: 4}();
        myStore.store{value: 5}();

        myStore.take();

        assert(true);
    }

    // function testAccessSafes() public {
    //     vm.deal(user, 123 wei);

    //     vm.prank(user);
    //     myStore.store{value: 123}();

    //     console.log(gasleft());
    //     do {
    //         payable(user).transfer(1);
    //     } while (gasleft() > 10000);
    //     console.log(gasleft());

    //     do {} while (gasleft() > 800);
    //     console.log(gasleft());

    //     vm.expectRevert();
    //     myStore.take();
    // }
}
