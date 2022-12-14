// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { StringUtils } from "./libraries/StringUtils.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

import "hardhat/console.sol";

contract Domains is ERC721URIStorage {

    // keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Top Level Domain
    string public tld;

    // NFT Images as SVGs
    string svgPartOne = '<svg xmlns="http://www.w3.org/2000/svg" width="270" height="270" fill="none"><path fill="url(#B)" d="M0 0h270v270H0z"/><defs><filter id="A" color-interpolation-filters="sRGB" filterUnits="userSpaceOnUse" height="270" width="270"><feDropShadow dx="0" dy="1" stdDeviation="2" flood-opacity=".225" width="200%" height="200%"/></filter></defs><path d="M72.863 42.949c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-10.081 6.032-6.85 3.934-10.081 6.032c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-8.013-4.721a4.52 4.52 0 0 1-1.589-1.616c-.384-.665-.594-1.418-.608-2.187v-9.31c-.013-.775.185-1.538.572-2.208a4.25 4.25 0 0 1 1.625-1.595l7.884-4.59c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v6.032l6.85-4.065v-6.032c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595L41.456 24.59c-.668-.387-1.426-.59-2.197-.59s-1.529.204-2.197.59l-14.864 8.655a4.25 4.25 0 0 0-1.625 1.595c-.387.67-.585 1.434-.572 2.208v17.441c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l10.081-5.901 6.85-4.065 10.081-5.901c.668-.387 1.426-.59 2.197-.59s1.529.204 2.197.59l7.884 4.59a4.52 4.52 0 0 1 1.589 1.616c.384.665.594 1.418.608 2.187v9.311c.013.775-.185 1.538-.572 2.208a4.25 4.25 0 0 1-1.625 1.595l-7.884 4.721c-.668.387-1.426.59-2.197.59s-1.529-.204-2.197-.59l-7.884-4.59a4.52 4.52 0 0 1-1.589-1.616c-.385-.665-.594-1.418-.608-2.187v-6.032l-6.85 4.065v6.032c-.013.775.185 1.538.572 2.208a4.25 4.25 0 0 0 1.625 1.595l14.864 8.655c.668.387 1.426.59 2.197.59s1.529-.204 2.197-.59l14.864-8.655c.657-.394 1.204-.95 1.589-1.616s.594-1.418.609-2.187V55.538c.013-.775-.185-1.538-.572-2.208a4.25 4.25 0 0 0-1.625-1.595l-14.993-8.786z" fill="#fff"/><defs><linearGradient id="B" x1="0" y1="0" x2="270" y2="270" gradientUnits="userSpaceOnUse"><stop stop-color="#cb5eee"/><stop offset="1" stop-color="#0cd7e4" stop-opacity=".99"/></linearGradient></defs><text x="32.5" y="231" font-size="27" fill="#fff" filter="url(#A)" font-family="Plus Jakarta Sans,DejaVu Sans,Noto Color Emoji,Apple Color Emoji,sans-serif" font-weight="bold">';
    string svgPartTwo = '</text></svg>';

    mapping (string => address) public domains;
    mapping (string => string) public records;

    constructor(string memory _tld) payable ERC721("Bulbul Name Service", "BNS") {
        tld = _tld;
        console.log("Deployed a Domains contract with TLD: %s", tld);
    }

    // Get price of domain based on length
    function price(string calldata domain) public pure returns (uint) {
        uint len = StringUtils.strlen(domain);
        require(len > 0, "Domain must be at least 1 character");
        if (len == 3) {
            return 5 * 10 ** 15; // 0.005
        } else if (len == 4) {
            return 3 * 10**15; // To charge smaller amounts, reduce the decimals. This is 0.003
        } else {
            return 1 * 10**15;
        }
    }

    // Register a domain
    function register(string calldata domain) public payable {
        // Check if domain is already registered
        // address(0) means there is nothing
        require(domains[domain] == address(0), "Domain already registered");

        uint _price = price(domain);
        require(msg.value >= _price, "Value below price");

        // Combine domain with TLD
        string memory _name = string(abi.encodePacked(domain, ".", tld));
        // Create the SVG
        string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(domain);
        string memory strLen = Strings.toString(length);
        
        console.log("Registering %s.%s on the contract with tokenID %d", domain, tld, newRecordId);

        // Create the JSON metadata of the NFT
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "Bulbul Name Service domain", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '", "length": "',
                strLen,
                '"}'
            )
        );

        string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64,", json));

        console.log("\n--------------------");
        console.log("Final token URI\n", finalTokenUri);
        console.log("--------------------\n");

        // Mint the NFT
        _safeMint(msg.sender, newRecordId);
        // Set the token URI
        _setTokenURI(newRecordId, finalTokenUri);
        domains[domain] = msg.sender;

        // Increment the token ID
        _tokenIds.increment();
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
