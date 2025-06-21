// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./SimpleCrowdfund.sol";

/**
 * @title CrowdfundFactory - A factory contract to create crowdfunding campaigns
 * @notice This contract allows users to create new crowdfunding contracts.
 * Each created contract is independent and can have its own owner, goal, and deadline.
 * @author Alberto Flores
 */
contract CrowdfundFactory {
    struct Crowdfund {
        address crowdfundAddress;
        address owner;
        uint256 goal;
        uint256 deadline;
    }

    mapping(uint256 => Crowdfund) public crowdfunds;
    uint256 public crowdfundCount;

    //Events
    event CrowdfundCreated(address indexed crowdfundAddress, address indexed owner, uint256 goal, uint256 deadline);

    /**
     * @notice Creates a new crowdfunding contract
     * @param _owner The address of the owner of the crowdfunding contract
     * @param _goal The funding goal (in wei) for the crowdfunding campaign
     * @param _deadline The deadline for the crowdfunding campaign (in Unix timestamp)
     */
    function createCrowdfund(address _owner, uint256 _goal, uint256 _deadline) external {
        SimpleCrowdfund newCrowdfund = new SimpleCrowdfund(_owner, _goal, _deadline);
        crowdfunds[crowdfundCount] =
            Crowdfund({crowdfundAddress: address(newCrowdfund), owner: _owner, goal: _goal, deadline: _deadline});
        crowdfundCount++;

        emit CrowdfundCreated(address(newCrowdfund), _owner, _goal, _deadline);
    }
}
