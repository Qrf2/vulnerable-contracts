# ReentrancyBank – Vulnerable Contract

This smart contract is vulnerable to a **Reentrancy Attack**.

## How it works:

1. A user deposits ETH to the contract using `deposit()`
2. They can withdraw using `withdraw()`
3. Inside `withdraw()`, the contract sends ETH **before** updating their balance.
4. If the receiver is a **smart contract**, it can call `withdraw()` **again** during the first call (before balance is set to 0).
5. This allows the attacker to **drain all ETH**.

## Code Vulnerability:

```solidity
(bool success, ) = msg.sender.call{value: amount}("");
balances[msg.sender] = 0; // This should be BEFORE sending ETH!
