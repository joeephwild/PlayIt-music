// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Spotify {
    uint256 musicCount;
    uint256 followerCount;
    uint registrationFee = 0.02 ethers;
    //two seperate segment listener and artist if(user == artsist){//run}
    //make an every month payment using solidity

    struct Music {
        string title;
        string musicUrl;
        address owner;
    }

    struct ArtistStruct {
        string name;
        string description;
        address artist;
        uint followerCount;
        uint music;
    }

    struct userStruct {
        string name;
        address user;
    }

    //an array of artist
    ArtistStruct[] artistArray;
    Music[] musicArray;

    mapping(address => mapping(address => bool)) followers;
    mapping(address => Music) musicMapping;

    //function to list a number of music to an account
    function listMusic(string memory name, string memory musicFile) public {
        require(registrationFee, "fees has to have been payed");
        musicCount += 1;
        Music storage newMusic = Music({
            title: name,
            music: musicFile,
            owner: msg.sender
        })
        musicCount ++;
        musicMapping[musicCount] = newMusic;
        musicArray.push(newMusic);
    }

    //function to retrieve the number of followers an account has
    function getFollowerCount() public view returns (uint256) {
        return followerCount;
    }

    //a function where user can follow a particular musician of choice
    function followAnAccount(uint _id) public {}

    //create account
    function createAnAccount() public {
        require(registrationFee, "fee has to be have been payed");
    }
}
