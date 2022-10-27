// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import { StringUtils } from "./libraries/StringUtils.sol";
import "hardhat/console.sol";

contract Domains {

    // Top Level Domain
    string public tld;

    mapping (string => address) public domains;

    mapping (string => string) public records;

    constructor(string memory _tld) payable {
        tld = _tld;
        console.log("Deployed a Domains contract with TLD: %s", tld);
    }

    // Get price of domain based on length
    function price(string calldata domain) public pure returns (uint) {
        uint len = StringUtils.strlen(domain);
        require(len > 0, "Domain must be at least 1 character");
        if (len == 3) {
            return 5 * 10 ** 17; // 5 MATIC
        } else if (len == 4) {
            return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
        } else {
            return 1 * 10**17;
        }
    }

    // Register a domain
    function register(string calldata domain) public payable {
        // Check if domain is already registered
        // address(0) means there is nothing
        require(domains[domain] == address(0), "Domain already registered");

        uint _price = price(domain);
        require(msg.value >= _price, "Value below price");
        
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
