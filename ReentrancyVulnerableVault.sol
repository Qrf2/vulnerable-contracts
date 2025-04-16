// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReentrancyVulnerableVault {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        require(msg.value > 0, "Send some ETH");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Not enough balance");

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send ETH");

        balances[msg.sender] -= _amount;
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
