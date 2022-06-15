// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

contract InfoFeed {
    function info() public pure returns (uint256) {
        return 42;
    }

    function pays() public payable returns (uint256) {
        return msg.value;
    }
}

contract Consumer {
    InfoFeed feed;

    receive() external payable {}

    function setFeed(InfoFeed addr) public {
        feed = addr;
    }

    function callFeed() public view returns (uint256) {
        uint256 result = feed.info();
        return result;
    }

    function callPays10() public returns (uint256) {
        uint256 result = feed.pays{value: 10}();
        return result;
    }

    function callPays(uint256 amount) public returns (uint256) {
        uint256 result = feed.pays{value: amount}();
        return result;
    }

    // TODO : add a callable method that transfer cash
}
