// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
 /**
  *  
    //two seperate segment listener and artist if(user == artsist){//run}
    //make an every month payment using solidity
  * list of unction needed in the dapp  
  * Create and manage user accounts
    Allow users to upload and share music tracks
    Set prices for tracks and manage payments
    Track playback and listening statistics
  */
contract Spotify {
    uint256 musicCount;
    uint256 followerCount;
    uint registrationFee;

    struct Music {
        string title;
        string musicUrl;
        address owner;
    }

    struct ArtistStruct {
        string name;
        string image;
        address artist;
        uint followerCount;
        uint music;
    }

    struct userStruct {
        string name;
        address user;
    }

 //holds the different account type a user 
 //can create an account has which will be used later for account creation
    enum AccountType {
        Artist,
        Listener
    }

  //constructor to hold the fee a user has to pay
    constructor() public {
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
    function followAnAccount(address _artist, address _listener) public {
         followers[_artist][_listener] = true;
         followerCount += 1;
    }
   
   //unFollow an account
   function unfollowAnAccount(address _artist, address _listener) public {
         delete followers[_artist][_listener];
         followerCount -= 1;
    }

    //create account
    function createAnAccount() public {
        require(registrationFee, "fee has to be have been payed");
    }

      // Define a mapping to store the price of each track
     mapping (bytes32 => uint) public trackPrices;

  // Define a function to allow the artist to set the price for their track
  function setTrackPrice(bytes32 trackId, uint price) public {
    trackPrices[trackId] = price;
  }
}
