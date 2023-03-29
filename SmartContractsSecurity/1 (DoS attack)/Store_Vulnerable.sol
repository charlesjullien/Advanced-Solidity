// *** Exercice 1 *** //
// Contract to store and redeem money.

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Store {
    struct Safe {
        address owner;
        uint amount;
    }
    
    Safe[] public safes;
    
    /// @dev Store some ETH.
    function store() public payable {
        safes.push(Safe({owner: msg.sender, amount: msg.value}));
    }
    
    /// @dev Take back all the amount stored.
    function take() public {
        for (uint i; i<safes.length; ++i) {
            Safe storage safe = safes[i];
            if (safe.owner==msg.sender && safe.amount!=0) {
                payable(msg.sender).transfer(safe.amount);
                safe.amount=0;
            }
        }
        
    }
}