// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title RejectEther - A contract that rejects any incoming ether
 * @notice This contract is used to test the behavior of the SimpleCrowdfund contract when it receives ether.
 */
contract RejectEther {
    fallback() external {
        revert("I reject ether");
    }
}
