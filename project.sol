// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AcademicAchievements {
    // Event emitted when a new token is minted
    event AchievementMinted(address indexed recipient, uint256 tokenId, string details);

    struct Achievement {
        uint256 tokenId;
        string details; // Description of the academic achievement
        string studentName;
        string institution;
        uint256 timestamp;
    }

    address public owner;
    uint256 public nextTokenId = 1;

    mapping(uint256 => Achievement) public achievements;
    mapping(address => uint256[]) public achievementsByStudent;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to mint a new academic achievement
    function mintAchievement(
        address recipient,
        string memory studentName,
        string memory institution,
        string memory details
    ) public onlyOwner {
        uint256 tokenId = nextTokenId;
        achievements[tokenId] = Achievement({
            tokenId: tokenId,
            details: details,
            studentName: studentName,
            institution: institution,
            timestamp: block.timestamp
        });

        achievementsByStudent[recipient].push(tokenId);
        nextTokenId++;

        emit AchievementMinted(recipient, tokenId, details);
    }

    // Function to get achievements of a student
    function getAchievements(address student) public view returns (Achievement[] memory) {
        uint256[] memory tokenIds = achievementsByStudent[student];
        Achievement[] memory studentAchievements = new Achievement[](tokenIds.length);

        for (uint256 i = 0; i < tokenIds.length; i++) {
            studentAchievements[i] = achievements[tokenIds[i]];
        }

        return studentAchievements;
    }

    // Function to get a specific achievement by tokenId
    function getAchievement(uint256 tokenId) public view returns (Achievement memory) {
        return achievements[tokenId];
    }
}
