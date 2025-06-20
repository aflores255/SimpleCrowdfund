// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title SimpleCrowdfund - A basic crowdfunding contract
 * @notice This contract allows users to contribute towards a funding goal within a specified deadline.
 * Contributors can withdraw their contributions if the goal is not met by the deadline.
 * If the goal is met, the owner can withdraw the funds.
 * If the deadline passes without meeting the goal, contributors can refund their contributions.
 * @author Alberto Flores
 */
contract SimpleCrowdfund is Ownable, ReentrancyGuard {
    uint256 public goal;
    uint256 public deadline;
    uint256 public amountRaised;
    uint256 public constant MIN_CONTRIBUTION = 0.01 ether;
    uint256 private extended = 0;

    mapping(address => uint256) public contributions;

    // Events
    event Contributed(address indexed contributor, uint256 amount);
    event Withdrawn(address indexed owner, uint256 amount);
    event Refunded(address indexed contributor, uint256 amount);
    event DeadlineExtended(uint256 newDeadline);

    /**
     * @notice Constructor to initialize the crowdfunding contract
     * @param _owner The address of the owner of the contract
     * @param _goal The funding goal (ether) for the crowdfunding campaign
     * @param _deadline The deadline for the crowdfunding campaign (in Unix timestamp)
     */
    constructor(address _owner, uint256 _goal, uint256 _deadline) Ownable(_owner) {
        require(_goal > 0, "Goal must be greater than zero");
        require(_deadline > block.timestamp, "Deadline must be in the future");
        goal = _goal;
        deadline = _deadline;
    }

    /**
     * @notice Allows users to contribute to the crowdfunding campaign
     */
    function contribute() external payable {
        require(block.timestamp < deadline, "Crowdfunding has ended");
        require(msg.value >= MIN_CONTRIBUTION, "Contribution must be greater than minimum amount");
        contributions[msg.sender] += msg.value;
        amountRaised += msg.value;
        emit Contributed(msg.sender, msg.value);
    }

    /**
     * @notice Allows the owner to withdraw funds if the goal is met
     */
    function withdraw() external onlyOwner nonReentrant {
        require(block.timestamp >= deadline || amountRaised >= goal, "Crowdfunding is still ongoing");
        require(amountRaised >= goal, "Funding goal not met");
        (bool success,) = msg.sender.call{value: amountRaised}("");
        require(success, "Withdrawal failed");
        emit Withdrawn(msg.sender, amountRaised);
    }

    /**
     * @notice Allows contributors to refund their contributions if the goal is not met
     */
    function refund() external nonReentrant {
        require(block.timestamp >= deadline, "Crowdfunding is still ongoing");
        require(amountRaised < goal, "Funding goal was met, no refunds allowed");
        require(contributions[msg.sender] >= MIN_CONTRIBUTION, "No contributions to refund");
        uint256 contributionAmount = contributions[msg.sender];
        contributions[msg.sender] = 0; // Reset contribution before sending to prevent re-entrancy
        (bool success,) = msg.sender.call{value: contributionAmount}("");
        require(success, "Refund failed");
        emit Refunded(msg.sender, contributionAmount);
    }

    /**
     * @notice Allows the owner to extend the deadline of the crowdfunding campaign
     * @param newDeadline The new deadline (in Unix timestamp) for the crowdfunding campaign
     */
    function extendDeadline(uint256 newDeadline) external onlyOwner {
        require(block.timestamp < deadline, "Crowdfunding has ended");
        require(newDeadline > deadline, "New deadline must be later than current deadline");
        require(extended == 0, "Deadline can only be extended once");
        extended = 1;
        deadline = newDeadline;
        emit DeadlineExtended(newDeadline);
    }

    /**
     * @notice Returns the current state of the crowdfunding campaign
     * @return true if the goal has been met, false otherwise
     */
    function isGoalMet() external view returns (bool) {
        return amountRaised >= goal;
    }
}
