// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract DiscountedBuy {
    uint public basePrice = 1 ether;
    mapping (address => uint) public objectBought;

    /// @dev Buy an object.
    function buy() public payable {
        require(msg.value == price()); // better to call price() fucntion here to get the exact price including a floor price
        objectBought[msg.sender] += 1;
    }
    
    /** @dev Return the price you'll need to pay.
     *  @return price The amount you need to pay in wei.
     */
    function price() public view returns (uint) {
        if (basePrice/(1 + objectBought[msg.sender]) == 0) // added a floor price condition if, after many purchases, the discount falls down to 0.
            return 1;
        else
            return basePrice/(1 + objectBought[msg.sender]);
    }
    
}