pragma solidity ^0.8.13;

import "hardhat/console.sol";

//*** Exercice 1 ***//
// Contract to store and redeem money.
contract Store {
    struct Safe {
        address owner;
        uint256 amount;
    }

    Safe[] public safes;

    /// @dev Stores some ETH.
    function store() public payable {
        safes.push(Safe({owner: msg.sender, amount: msg.value}));
    }

    /// @dev Takes back all the amount stored.
    function take() public {
        for (uint256 i; i < safes.length; ++i) {
            console.log("step 1");
            Safe storage safe = safes[i];
            if (safe.owner == msg.sender && safe.amount != 0) {
                console.log("step 2");
                payable(msg.sender).transfer(safe.amount);
                console.log("step 3");
                safe.amount = 0;
            }
        }
    }
}
