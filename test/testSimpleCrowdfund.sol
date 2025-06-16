//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity ^0.8.28;

import "forge-std/Test.sol";

import "../src/SimpleCrowdfund.sol";

/**
 * @title SimpleCrowdfundTest - A test suite for the SimpleCrowdfund contract
 * @notice This contract contains tests for the SimpleCrowdfund contract using Foundry's testing framework.
 * @author Alberto Flores
 */
contract SimpleCrowdfundTest is Test {
    SimpleCrowdfund public crowdfund;

    address public owner = vm.addr(1);
    address public contributor = vm.addr(2);
    address public nonContributor = vm.addr(3);
    uint256 public goal = 10 ether;
    uint256 public deadline = block.timestamp + 30 days;

    /**
     * @notice Sets up the crowdfunding contract for testing
     */
    function setUp() public {
        crowdfund = new SimpleCrowdfund(owner, goal, deadline);
    }

    //Unit tests

    function testWrongConstruction() public {
        vm.expectRevert("Goal must be greater than zero");
        new SimpleCrowdfund(owner, 0, deadline);

        vm.expectRevert("Deadline must be in the future");
        new SimpleCrowdfund(owner, goal, block.timestamp - 1);

        vm.expectRevert();
        new SimpleCrowdfund(address(0), goal, deadline);
    }

    /**
     * @notice Tests the initial values of the crowdfunding contract
     */
    function testInitialValues() public view {
        assertEq(crowdfund.goal(), goal);
        assertEq(crowdfund.deadline(), deadline);
        assertEq(crowdfund.amountRaised(), 0);
        assertEq(crowdfund.owner(), owner);
    }

    /**
     * @notice Tests the contribution functionality
     */
    function testContributeCorrectly() public {
        uint256 contributionAmount = 1 ether;
        uint256 initialWalletBalance = 100 ether;
        vm.startPrank(contributor);
        vm.deal(contributor, initialWalletBalance);
        uint256 initialBalance = address(crowdfund).balance;
        uint256 contributorInitialBalance = address(contributor).balance;
        crowdfund.contribute{value: contributionAmount}();
        assertEq(crowdfund.amountRaised(), contributionAmount);
        assertEq(crowdfund.contributions(contributor), contributionAmount);
        assertEq(initialBalance, 0);
        assertEq(address(crowdfund).balance, contributionAmount);
        assertEq(address(contributor).balance, contributorInitialBalance - contributionAmount);

        vm.stopPrank();
    }

    /**
     * @notice Tests multiple contributions from the same contributor
     */
    function testMultipleContributions() public {
        uint256 firstContribution = 1 ether;
        uint256 secondContribution = 2 ether;
        uint256 initialWalletBalance = 100 ether;
        vm.startPrank(contributor);
        vm.deal(contributor, initialWalletBalance);

        // First contribution
        crowdfund.contribute{value: firstContribution}();
        assertEq(crowdfund.amountRaised(), firstContribution);
        assertEq(crowdfund.contributions(contributor), firstContribution);
        assertEq(address(crowdfund).balance, firstContribution);
        assertEq(address(contributor).balance, initialWalletBalance - firstContribution);

        // Second contribution
        crowdfund.contribute{value: secondContribution}();
        assertEq(crowdfund.amountRaised(), firstContribution + secondContribution);
        assertEq(crowdfund.contributions(contributor), firstContribution + secondContribution);
        assertEq(address(crowdfund).balance, firstContribution + secondContribution);
        assertEq(address(contributor).balance, initialWalletBalance - firstContribution - secondContribution);

        vm.stopPrank();
    }

    /**
     * @notice Test contributions if deadline has passed
     */
    function testCannotContributeAfterDeadline() public {
        vm.warp(deadline + 1);
        uint256 contributionAmount = 1 ether;
        uint256 initialWalletBalance = 100 ether;
        vm.startPrank(contributor);
        vm.deal(contributor, initialWalletBalance);
        uint256 initialBalance = address(crowdfund).balance;
        uint256 contributorInitialBalance = address(contributor).balance;
        vm.expectRevert("Crowdfunding has ended");
        crowdfund.contribute{value: contributionAmount}();
        assertEq(crowdfund.amountRaised(), 0);
        assertEq(crowdfund.contributions(contributor), 0);
        assertEq(initialBalance, 0);
        assertEq(address(crowdfund).balance, 0);
        assertEq(contributorInitialBalance, initialWalletBalance);
        vm.stopPrank();
    }

    /**
     * @notice Tests contributions with zero amount
     */
    function testCannotContributeWithZeroAmount() public {
        uint256 contributionAmount = 0 ether;
        uint256 initialWalletBalance = 100 ether;
        vm.startPrank(contributor);
        vm.deal(contributor, initialWalletBalance);
        uint256 initialBalance = address(crowdfund).balance;
        uint256 contributorInitialBalance = address(contributor).balance;
        vm.expectRevert("Contribution must be greater than zero");
        crowdfund.contribute{value: contributionAmount}();
        assertEq(crowdfund.amountRaised(), contributionAmount);
        assertEq(crowdfund.contributions(contributor), contributionAmount);
        assertEq(initialBalance, 0);
        assertEq(address(crowdfund).balance, contributionAmount);
        assertEq(address(contributor).balance, contributorInitialBalance);
        vm.stopPrank();
    }
}
