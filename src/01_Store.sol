pragma solidity ^0.8.13;

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
            Safe storage safe = safes[i];
            if (safe.owner == msg.sender && safe.amount != 0) {
                payable(msg.sender).transfer(safe.amount);
                safe.amount = 0;
            }
        }
    }

    function getLen() public view returns (uint256) {
        return safes.length;
    }

    function getAmount(uint256 i) public view returns (uint256) {
        return safes[i].amount;
    }

    function getAdr(uint256 i) public view returns (address) {
        return safes[i].owner;
    }
}
