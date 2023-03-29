// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Store {

    mapping(address => uint) public safes; // mapping is better : One safe for one user.

    /// @dev Store some ETH.
    function store() public payable {
        require(msg.value > 0,"Err!"); // User cannot deposit 0 ETH
        safes[msg.sender] = safes[msg.sender] + msg.value;
    }

    /// @dev Take back all the amount stored.
    function take() public {
        require(safes[msg.sender] > 0, "Err!"); // User must withdraw something (not 0 ETH)
        uint256 _amount = safes[msg.sender]; // we copy the stored amount in a var...
        delete safes[msg.sender]; // ...Then delete the safe
        payable(msg.sender).transfer(_amount); // to send the amount to user
    }
}