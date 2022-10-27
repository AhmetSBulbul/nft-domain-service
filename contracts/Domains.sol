// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "hardhat/console.sol";

contract Domains {

    mapping (string => address) public domains;

    mapping (string => string) public records;

    constructor() {
        console.log("Deploying a Domains contract");
    }

    // Register a domain
    function register(string calldata domain) public {
        // Check if domain is already registered
        // address(0) means there is nothing
        require(domains[domain] == address(0), "Domain already registered");
        domains[domain] = msg.sender;
        console.log("Registered domain %s for %s", domain, msg.sender);
    }

    // Get the owner of a domain
    function getOwner(string calldata domain) public view returns (address) {
        return domains[domain];
    }

    // Set a record
    function setRecord(string calldata domain, string calldata record) public {
        // Check if sender is the owner of the domain
        require(domains[domain] == msg.sender, "You are not the owner of this domain");
        records[domain] = record;
        console.log("Set record %s for domain %s", record, domain);
    }

    // Get a record
    function getRecord(string calldata domain) public view returns (string memory) {
        return records[domain];
    }
}
