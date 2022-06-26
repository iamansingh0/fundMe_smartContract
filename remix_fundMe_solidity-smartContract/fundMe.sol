// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./priceConvertor.sol";

contract fundMe {

    using priceConvertor for uint256;

    uint256 public constant minUsd = 5 * 1e18;
    // 23515 gas - non-constant
    // 21415 gas - constant

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public immutable i_owner;
    // 23644 gas - non-immutable
    // 21508 gas - immutable
    constructor(){
        i_owner = msg.sender; 
    }

    function fund() public payable{
        // set minimum fund amount in USD
        require(msg.value.getConversionRate() >= minUsd, "Didn't send enough");
        // 1e18 = 1*10 ** 18 == value of wei for 1 eth
        // msg.value will have 18 decimal places
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; // in wei
    }

    function withdraw() public onlyOwner {
        
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++)
        {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0); //reset the array

        // actually withdraw the funds
        // msg.sender = address
        // payable(msg.sender) = payable address
        // call
        (bool callSuccess, /* bytes memory dataReturned */) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");
    }

    modifier onlyOwner {
        require(msg.sender == i_owner, "Sender is not owner");
        _;
    }

    // what happens if someone sends this contract eth without calling fund
    // receive
    // fallback

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}