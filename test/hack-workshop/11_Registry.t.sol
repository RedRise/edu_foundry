//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "hack-workshop/SolidityHackingWorkshopV8.sol";

contract RegistryTest is Test {
    Registry reg;
    address alice;

    function setUp() public {
        alice = address(7777);
        reg = new Registry();
    }

    function testSimpleRegistration() public {
        reg.register("alice", "carroll", 7777);

        bytes32 aliceId = keccak256(
            abi.encodePacked("alice", "carroll", uint256(7777))
        );

        address payable regAddress;
        uint64 timestamp;
        bool registered;
        string memory name;
        string memory surname;
        uint256 nonce;

        (regAddress, timestamp, registered, name, surname, nonce) = reg.users(
            aliceId
        );
        assertEq(name, "alice");
        assertEq(surname, "carroll");
    }

    function testDoubleSameRegistration() public {
        reg.register("alice", "carroll", 7777);
        vm.expectRevert("This profile is already registered");
        reg.register("alice", "carroll", 7777);
    }

    function testIsRegistered() public {
        vm.prank(alice);
        reg.register("alice", "carroll", uint256(7777));
        bool isRegistered = reg.isRegistered("alice", "carroll", 7777);
        assert(isRegistered);
    }

    function testInProgress() public {
        assert(false);
    }
}
