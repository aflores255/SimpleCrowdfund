
# 🚀 SimpleCrowdfund – A Secure and Refundable Crowdfunding Smart Contract in Solidity

## 📌 Description

**SimpleCrowdfund** is a minimalist, yet powerful Ethereum smart contract designed to bring transparency, fairness, and trust to crowdfunding campaigns.

🚀 Unlike traditional platforms that rely on intermediaries, **SimpleCrowdfund** runs entirely on-chain — meaning **no platform fees**, **no censorship**, and **guaranteed logic enforcement**. It’s ideal for startups, creators, communities, or developers looking to raise ETH securely and transparently from supporters.

Whether you're launching a new idea or backing one, **SimpleCrowdfund** ensures that:
- 💸 **Funds are only released if the funding goal is reached**, protecting contributors from failed or abandoned projects.
- 🔁 **Automatic refunds are guaranteed** if the goal isn't met by the deadline — no need to rely on third parties.
- 🔐 **Security is built-in**, using audited OpenZeppelin libraries and protections like reentrancy guards and strict ownership controls.
- ⏳ **Deadlines can be extended once**, providing flexibility while maintaining trust.

This contract gives backers peace of mind and empowers project owners with a trustless fundraising tool that can be easily deployed, customized, and integrated into any DApp or Web3 experience.

Built with **Solidity 0.8.28**, the contract includes basic protections such as **reentrancy guards** and ownership control using OpenZeppelin libraries.

---

## 🧩 Features

| **Feature**                 | **Description**                                                               |
|-----------------------------|-------------------------------------------------------------------------------|
| 💰 **ETH Contributions**     | Users can contribute ETH towards the crowdfunding goal.                      |
| ⏰ **Deadline Control**       | Contributions only accepted before the deadline.                             |
| 🧭 **Deadline Extension**     | Owner can extend the deadline one time, only before it ends.  
| 🎯 **Funding Goal**           | The contract tracks whether the funding goal has been reached.               |
| 💸 **Owner Withdrawal**       | Owner can withdraw funds only if the goal is met after the deadline or early.|
| 🔄 **Contributor Refunds**    | Contributors can refund their ETH if goal is not met by the deadline.        |
| 🛡️ **ReentrancyGuard**       | Protection against reentrancy attacks on withdrawals and refunds.            |
| 🔑 **Ownable**                | Ownership control for withdrawal functionality.                              |

---

## 📜 Contract Details

### ⚙️ Constructor

```solidity
constructor(address _owner, uint256 _goal, uint256 _deadline)
```

Initializes the crowdfunding contract with the owner address, funding goal (in wei), and campaign deadline (Unix timestamp).

---

### 🔧 Functions

| **Function**       | **Description**                                                                 |
|--------------------|---------------------------------------------------------------------------------|
| `contribute()`     | Allows users to send ETH as contributions before the deadline.                  |
| `withdraw()`       | Allows the owner to withdraw funds if the goal is met and deadline passed.      |
| `refund()`         | Allows contributors to refund their ETH if the funding goal is not met.         |
| `extendDeadline()	`| Allows the owner to extend the deadline once, before it expires.                |
| `isGoalMet()`      | Returns whether the funding goal has been reached.                             |

---

### 📡 Events

| **Event**      | **Description**                                        |
|----------------|--------------------------------------------------------|
| `Contributed`  | Emitted when a user successfully contributes ETH.     |
| `Withdrawn`    | Emitted when the owner withdraws funds.                |
| `Refunded`     | Emitted when a contributor successfully refunds ETH.  |
| `DeadlineExtended`| Emitted when the deadline is extended by the owner.|

---

### 🔐 Validations & Security

- ❌ Contributions are **rejected** after the deadline.
- ❌ Zero-value contributions are not allowed.
- ✅ Only the **owner** can withdraw funds.
- ❌ Refunds are not allowed if the funding goal is reached.
- ✅ Uses **ReentrancyGuard** to protect against reentrancy attacks.
- ✅ Prevents refunding more than the original contribution.
- ❌ Deadline can only be extended once, and only before it ends.

---

## 🧪 Testing with Foundry

The contract is thoroughly tested using **Foundry**, with complete coverage across all major functionalities.

Two helper contracts are used to simulate edge cases and failure scenarios:

- **`RejectEther`**: Simulates a contract that **refuses to accept ETH**, used to test how the crowdfund contract handles failed withdrawals to the owner.
- **`RejectRefund`**: Simulates a contributor that **rejects refunds**, ensuring the refund logic handles recipient-side failures safely.

### 🧪 Test Cases

| Test Function                            | Purpose                                                                 |
|------------------------------------------|-------------------------------------------------------------------------|
| `testWrongConstruction`                  | Ensures constructor fails with invalid inputs (zero goal, past deadline). |
| `testInitialValues`                      | Confirms correct setup of owner, goal, deadline, etc.                   |
| `testContributeCorrectly`                | Tests ETH contribution functionality.                                  |
| `testMultipleContributions`              | Verifies correct accumulation per contributor.                         |
| `testCannotContributeAfterDeadline`      | Ensures no contributions are accepted after deadline.                  |
| `testCannotContributeWithZeroAmount`     | Rejects contributions of 0 ETH.                                        |
| `testWithdrawCorrectly`                  | Owner can withdraw funds if goal is met after deadline.                |
| `testCannotWithdrawBeforeDeadline`       | Prevents withdrawal before deadline.                                   |
| `testCannotWithdrawIfGoalNotMet`         | Prevents withdrawal if goal not reached.                               |
| `testCannotWithdrawNotOwner`             | Only owner can call `withdraw()`.                                      |
| `testConsultIfGoalIsMet`                 | Checks positive result for `isGoalMet()` when goal is reached.         |
| `testConsultIfGoalIsNotMet`              | Checks negative result for `isGoalMet()` if goal not reached.          |
| `testRefundCorrectly`                    | Refund works when goal not met after deadline.                         |
| `testCannotRefundBeforeDeadline`         | Refund fails before deadline.                                          |
| `testCannotRefundGoalMet`                | Refund fails if funding goal is met.                                   |
| `testCannotRefundIfNoContributions`      | Refund fails for users who never contributed.                          |
| `testWithdrawFailsIfOwnerRejectsEther`   | Uses `RejectEther` to test withdrawal failure when owner rejects ETH.  |
| `testRefundFailsIfReceiverRejectsEther`  | Uses `RejectRefund` to test refund failure when contributor rejects ETH.|
| `testExtendDeadline`                     | Verifies the owner can successfully extend the deadline before it ends. |
| `testCannotExtendDeadlineNotLater`       | Ensures extension fails if new deadline is not later than current one. |
| `testCannotExtendDeadlineIfAlreadyPassed`| Prevents deadline extension after the crowdfunding has ended. |
| `testCannotExtendDeadlineIfAlreadyExtended`| Verifies that the deadline can only be extended once. |
| `testCannotExtendDeadlineIfNotOwner`     | Ensures only the owner can extend the deadline. |
| `testFuzzContributeAmount`               | Tests single contributions using random valid ETH amounts.             |
| `testFuzzMultipleContributors`           | Verifies balance tracking for multiple random contributors and amounts.|
| `testFuzzWithdrawAfterGoal`              | Ensures the owner can withdraw funds when a fuzzed amount ≥ goal is reached. |
| `testFuzzRefund`                         | Confirms that refunds work correctly for random amounts < goal after the deadline. |


To run all tests with Foundry:

```bash
forge test
```

### 📊 Coverage Report

| File                    | % Lines         | % Statements     | % Branches      | % Functions     |
|-------------------------|------------------|-------------------|------------------|------------------|
| `src/SimpleCrowdfund.sol` | 100.00% (34/34) | 100.00% (31/31) | 100.00% (28/28) | 100.00% (6/6)   |


## 🔗 Dependencies

- [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts)
  - `Ownable.sol`
  - `ReentrancyGuard.sol`

---

## 🛠️ How to Use

### 🔧 Prerequisites

- Install [Foundry](https://book.getfoundry.sh/getting-started/installation) or preferred Solidity development environment.
- Wallet with ETH to contribute.
- Deploy the contract with valid owner address, funding goal, and future deadline.


### 🚀 Deployment Example

```solidity
new SimpleCrowdfund(ownerAddress, 10 ether, block.timestamp + 7 days);
```

---

## 📄 License

This project is licensed under the **MIT License**.
