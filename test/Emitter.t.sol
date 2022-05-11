// UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/Emitter.sol";

contract EmitterTest is Test {

    event Blip(uint indexed count, string message);

    Emitter emitter;

    function setUp() public {
        emitter = new Emitter();
    }

    function testEmitterBlip() public {

        vm.expectEmit(true, false, false, false);

        string memory message = "It's me";

        emit Blip(0, message);
        
        emitter.TocToc(message);
    }

    function testEmitterBlipTwice() public {

        emitter.TocToc("");

        vm.expectEmit(true, false, false, false);

        emit Blip(1, "");
        
        emitter.TocToc("");

    }

}