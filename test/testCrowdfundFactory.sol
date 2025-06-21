// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/CrowdfundFactory.sol";
import "../src/SimpleCrowdfund.sol";

/**
 * @title CrowdfundFactoryTest - Tests for the CrowdfundFactory contract
 * @notice This contract tests the functionality of the CrowdfundFactory, ensuring that it correctly creates and tracks crowdfunding campaigns.
 *  @author Alberto FloresS
 */
contract CrowdfundFactoryTest is Test {
    CrowdfundFactory factory;
    address owner;
    address user;
    uint256 goal;
    uint256 deadline;

    /**
     *   @notice Sets up the test environment by initializing the factory and setting the owner and user addresses.
     */
    function setUp() public {
        owner = address(this);
        user = vm.addr(1);
        factory = new CrowdfundFactory();
        goal = 1 ether;
        deadline = block.timestamp + 1 days;
    }

    /**
     *    @notice Tests that the initial crowdfund count is zero.
     */
    function testInitialCrowdfundCountIsZero() public view {
        assertEq(factory.crowdfundCount(), 0);
    }

    /**
     *    @notice Tests that creating a crowdfund increments the crowdfund count.
     */
    function testCreateCrowdfundIncrementsCount() public {
        factory.createCrowdfund(owner, goal, deadline);
        assertEq(factory.crowdfundCount(), 1);
    }

    /**
     *     @notice Tests that creating a crowdfund stores the correct data in the factory.
     */
    function testCreateCrowdfundStoresCorrectData() public {
        factory.createCrowdfund(owner, goal, deadline);

        (address crowdfundAddr, address campaignOwner, uint256 campaignGoal, uint256 campaignDeadline) =
            factory.crowdfunds(0);

        assertEq(campaignOwner, owner);
        assertEq(campaignGoal, goal);
        assertEq(campaignDeadline, deadline);

        // Test the deployed crowdfund instance
        SimpleCrowdfund crowdfund = SimpleCrowdfund(crowdfundAddr);
        assertEq(crowdfund.goal(), goal);
        assertEq(crowdfund.deadline(), deadline);
        assertEq(crowdfund.owner(), owner);
    }
}
