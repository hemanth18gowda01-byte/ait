// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract KeyProtectedVault {
    bytes32 private keyHash; // Stores hash of the secret key
    address public owner;

    constructor(string memory secretKey) payable {
        owner = msg.sender;
        keyHash = keccak256(bytes(secretKey)); // Store only hash
    }

    function withdraw(string memory providedKey) public {
        require(keccak256(bytes(providedKey)) == keyHash, "Invalid key");
        payable(msg.sender).transfer(address(this).balance);
    }
}
