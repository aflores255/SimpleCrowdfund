// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "../../src/SimpleCrowdfund.sol";

/**
 * @title RejectRefund - Rejects any attempt to receive ether or refund
 */
contract RejectRefund {
    receive() external payable {
        revert("Refund rejected");
    }

    fallback() external payable {
        revert("Refund rejected");
    }

    function contributeTo(SimpleCrowdfund crowdfund) external payable {
        crowdfund.contribute{value: msg.value}();
    }

    function tryRefund(SimpleCrowdfund crowdfund) external {
        crowdfund.refund();
    }
}
