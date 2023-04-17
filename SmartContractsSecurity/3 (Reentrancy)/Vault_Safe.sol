//*** Solution 4 ***//
// reset balance before the call

// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Vault {
    mapping(address => uint) public balances;

    /// @dev Store ETH in the contract.
    function store() public payable {
        balances[msg.sender]+= msg.value;
    }

    /// @dev Redeem your ETH.
    /// @dev Solution : added a boolean + require to verify the call has been done properly.
    function redeem() public {
        (bool sent, bytes memory data) = msg.sender.call{ value: balances[msg.sender] }("");
	require(sent);
        balances[msg.sender] = 0;
    }
}
