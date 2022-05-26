// SPDX-License-Identifier: MIT
// Deployed at 0xF0033c73a3C655997f84271fE4656CE19D246e70.
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct PlayerStats {
        string position;
        uint level;
        uint attack;
        uint defence;
        uint speed;
    }
    
    mapping (uint256 => PlayerStats) public tokenIdtoStats;

    constructor() ERC721("ChainBattles", "CBTLS"){
}

    function generateCharacter(uint _tokenId) view public returns (string memory){
         bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.heading { fill : #000000; font-size: 35px; font-family: monospace; }</style>',
        '<style>.base { fill: rgb(103, 5, 70); font-family: monospace; font-size: 25px; }</style>',
        '<style>.level { fill: rgb(5, 73, 23); font-family: fantasy; font-size: 18px; }</style>',
        '<style>.attack { fill: rgb(202, 25, 25); font-family: fantasy; font-size: 18px; }</style>',
        '<style>.defence { fill: rgb(16, 90, 105); font-family: fantasy; font-size: 18px; }</style>',
        '<style>.speed { fill: rgb(37, 5, 51); font-family: fantasy; font-size: 18px; }</style>',
        '<rect width="100%" height="100%" fill="#dedede" />',
        '<text x="50%" y="25%" class="heading" dominant-baseline="middle" text-anchor="middle"> Chain Battles.</text>',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', getPosition(_tokenId),'</text>',
        '<text x="50%" y="50%" class="level" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevels(_tokenId),'</text>',
        '<text x="50%" y="60%" class="attack" dominant-baseline="middle" text-anchor="middle">', "Attack: +",getAttack(_tokenId),'</text>',
        '<text x="50%" y="70%" class="defence" dominant-baseline="middle" text-anchor="middle">', "Defence: +",getDefence(_tokenId),'</text>',
        '<text x="50%" y="80%" class="speed" dominant-baseline="middle" text-anchor="middle">', "Speed: +",getSpeed(_tokenId),'</text>',
        '</svg>');

         return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }



    function getLevels(uint _tokenId) public view returns (string memory){
        uint256 level = tokenIdtoStats[_tokenId].level;
        return level.toString();
    }

    function getPosition(uint _tokenId) public view returns (string memory){
        string memory position = tokenIdtoStats[_tokenId].position;
        return position;
    }

    function getAttack(uint _tokenId) public view returns (string memory){
        PlayerStats memory stats = tokenIdtoStats[_tokenId];
        uint256 attack = stats.attack;
        return attack.toString();
    }

    function getDefence(uint _tokenId) public view returns (string memory){
        PlayerStats memory stats = tokenIdtoStats[_tokenId];
        uint256 defence = stats.defence;
        return defence.toString();
    }

    function getSpeed(uint _tokenId) public view returns (string memory){
        PlayerStats memory stats = tokenIdtoStats[_tokenId];
        uint256 speed = stats.speed;
        return speed.toString();
    }




    function getTokenURI(uint256 _tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', _tokenId.toString(), '",',
                '"description": "Battles on chain.",',
                '"image": "', generateCharacter(_tokenId), '"',
            '}'
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint(string memory _position) public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdtoStats[newItemId].position = _position;
        tokenIdtoStats[newItemId].level = 0;
        tokenIdtoStats[newItemId].attack = 10;
        tokenIdtoStats[newItemId].defence = 5;
        tokenIdtoStats[newItemId].speed = 20;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 _tokenId) public {
        require(_exists(_tokenId), "Token does not exist");
        require(msg.sender == ownerOf(_tokenId), "Only owner can train.");
        tokenIdtoStats[_tokenId].level++;
        tokenIdtoStats[_tokenId].attack += 21;
        tokenIdtoStats[_tokenId].defence += 9;
        tokenIdtoStats[_tokenId].speed += 12;
        _setTokenURI(_tokenId, getTokenURI(_tokenId));
    }

}