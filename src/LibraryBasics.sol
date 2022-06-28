//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

library CustomUintArray {
    function indexOf(uint256[] memory self, uint256 value)
        public
        pure
        returns (bool, uint256)
    {
        for (uint256 i = 0; i < self.length; ++i) {
            if (self[i] == value) {
                return (true, i);
            }
        }
        return (false, 0);
    }
}

contract ContractUsingLibrary {
    using CustomUintArray for uint256[];

    function getIndexOf(uint256[] memory array, uint256 value)
        public
        pure
        returns (bool, uint256)
    {
        return array.indexOf(value);
    }
}
