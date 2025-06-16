// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SimpleCrowdfund - A basic crowdfunding contract
 * @notice This contract allows users to contribute towards a funding goal within a specified deadline.
 * Contributors can withdraw their contributions if the goal is not met by the deadline.
 * If the goal is met, the owner can withdraw the funds.
 * If the deadline passes without meeting the goal, contributors can refund their contributions.
 * @author Alberto Flores
 */

contract SimpleCrowdfund is Ownable {
    uint256 public goal;
    uint256 public deadline;
    uint256 public amountRaised;

    mapping(address => uint256) public contributions;

    /**
     * @notice Constructor to initialize the crowdfunding contract
     * @param _owner The address of the owner of the contract
     * @param _goal The funding goal (ether) for the crowdfunding campaign
     * @param _deadline The deadline for the crowdfunding campaign (in Unix timestamp)
     */
    constructor(address _owner, uint256 _goal, uint256 _deadline) Ownable(_owner) {
        require(_goal > 0, "Goal must be greater than zero");
        require(_deadline > block.timestamp, "Deadline must be in the future");
        require(_owner != address(0), "Owner cannot be the zero address");
        goal = _goal;
        deadline = _deadline;
    }

    // function contribute() external payable { ... }
    // function withdraw() external { ... }
    // function refund() external { ... }
}
