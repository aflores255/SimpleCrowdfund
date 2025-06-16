//1. License
//SPDX-License-Identifier: MIT

//2. Solidity
pragma solidity ^0.8.28;

import "forge-std/Test.sol";

import "../src/SimpleCrowdfund.sol";

contract SimpleCrowdfundTest is Test {
    SimpleCrowdfund public crowdfund;

    address public owner = vm.addr(1);
    uint256 public goal = 1 ether;
    uint256 public deadline = block.timestamp + 30 days;

    function setUp() public {
        crowdfund = new SimpleCrowdfund(owner, goal, deadline);
    }

    function testInitialValues() public view {
        assertEq(crowdfund.goal(), goal);
        assertEq(crowdfund.deadline(), deadline);
        assertEq(crowdfund.amountRaised(), 0);
        assertEq(crowdfund.owner(), owner);
    }
}
