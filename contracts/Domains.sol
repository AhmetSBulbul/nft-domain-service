// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains {

    mapping (string => address) public domains;

    constructor() {
        console.log("Deploying a Domains contract");
    }

    // Register a domain
    function register(string calldata domain) public {
        domains[domain] = msg.sender;
        console.log("Registered domain %s for %s", domain, msg.sender);
    }

    // Get the owner of a domain
    function getOwner(string calldata domain) public view returns (address) {
        return domains[domain];
    }
}
