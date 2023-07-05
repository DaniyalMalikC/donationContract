// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract DonationContract {
    uint256 totalDonation;
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    event NewDonation (
        address indexed from,
        uint256 timestamp,
        string recepient,
        string name
    );

    struct Donation {
        address sender;
        string recepient;
        string name;
        uint256 timestamp;
    }

    Donation[] donation;

    function getAllDonation() public view returns (Donation[] memory) {
        return donation;
    }    

    function getTotalDonation() public view returns (uint256) {
        return totalDonation;
    }

    function createDonation(
        string memory _recepient,
        string memory _name
    ) payable public {
        require(msg.value >= 0.0001 ether, "You need to pay atleast 0.0001 ETH");

        totalDonation += 1;
        donation.push(Donation(msg.sender, _recepient, _name, block.timestamp));

        (bool success,) = owner.call{value: msg.value}("");
        require(success, "Failed to send Ether to owner");

        emit NewDonation(msg.sender, block.timestamp, _recepient, _name);
    }
}