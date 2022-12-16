// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

/**
  *  
    //two seperate segment listener and artist if(user == artsist){//run}
    //make an every month payment using solidity
  * list of function needed in the dapp  
  * 1: Create and manage user accounts ✔
    2: Allow users to upload and share music tracks ✔
    3: Set prices for tracks and manage payments✔
    4: Track playback and listening statistics
  */
contract Spotify {
    struct Music {
        string title;
        string name;
        string musicFile;
        string image;
        address owner;
        uint256[] trackPrice;
        address[] donators;
        uint256 amountCollected;
    }

    struct ArtistStruct {
        string name;
        address owner;
        string image;
        string coverImage;
        string genre;
        uint256 listener;
        uint256 supporters;
    }

    ArtistStruct[] artist;
    Music[] music;
    mapping(address => mapping(address => bool)) public followers;
    mapping(uint256 => Music) public musics;
    mapping(address => ArtistStruct) public artists;

    uint256 public numberOfMusic = 0;
    //uint256 musicCount;
    uint256 numberOfFollowers;
    //to keep track of number of supporters
    uint256 numberOfSupporter;
    //to keep track of plays
    uint256 numberOfPlays;

   //create an accouunt
    function createAnAccount(
        string memory _name,
        string memory _image,
        string memory _coverImage
    ) public {
        ArtistStruct storage creator = artists[msg.sender];
        creator.name = _name;
        creator.owner = msg.sender;
        creator.image = _image;
        creator.coverImage = _coverImage;
        creator.listener = numberOfFollowers;
        creator.supporters = numberOfSupporter;
        artist.push(creator);
    }

    //get all artist
    function getArtist() public view returns (ArtistStruct[] memory) {
        return artist;
    }


   //update a particular section of an account 
    function updateAccount(
        address _owner,
        string memory data,
        uint256 option
    ) external {
        ArtistStruct storage creator = artists[_owner];
        require(
            creator.owner == msg.sender,
            "only account owner can make changes to an account"
        );
        if (option == 0) {
            creator.name = data;
        } else if (option == 2) {
            creator.image = data;
        } else if (option == 3) {
            creator.coverImage = data;
        }
    }

    //delete an account
    function deleteAccount(address _pubkey) external {
        ArtistStruct storage creator = artists[_pubkey];
        require(
            creator.owner == msg.sender,
            "only account owner can make changes to an account"
        );
        delete artists[_pubkey];
    }

   //upload a new music
    function uploadMusic(
        uint256 _owner,
        string memory _title,
        string memory _name,
        string memory _file,
        string memory _image
    ) external returns (uint256) {
      Music storage playlist = musics[_owner];
      //require(music.owner == msg.sender, "");
      playlist.title = _title;
      playlist.name = _name;
      playlist.musicFile = _file;
      playlist.image = _image;
      playlist.owner = msg.sender;
      music.push(playlist);
      numberOfMusic++;
      return numberOfMusic - 1;
    }

   //follow abd account
    function followAnAccount(address _artist, address _listener) public {
         followers[_artist][_listener] = true;
         numberOfFollowers += 1;
    }

   //unfollow an account
    function unfollowAnAccount(address _artist, address _listener) public {
         delete followers[_artist][_listener];
         numberOfFollowers -= 1;
    }

   //get number of followers
    function getFollowerCount() public view returns (uint256) {
        return numberOfFollowers;
    }
 
    //donate to a particular music
    function donateToMusic(uint256 _id) external payable {
        uint256 amount = msg.value;

        Music storage playlist = musics[_id];
        //require(msg.sender !== playlist.owner, "");

        playlist.donators.push(msg.sender);
        playlist.trackPrice.push(amount);

       (bool sent, ) = payable(playlist.owner).call{value: amount}("");
       if(sent){
        playlist.amountCollected = playlist.amountCollected + amount;
       }
    }


    //Get every list of music in the blockchain
    function getAllMusic() public view returns(Music[] memory){
        Music[] memory allMusic = new Music[](numberOfMusic);

        for (uint256 i = 0; i < numberOfMusic; i++) {
            Music storage item = musics[i];

            allMusic[i] = item;
        }
        return allMusic;
    }

    //fetch every supporters of a particular music
     function getAllSupporters(uint256 _id) public view returns(address[] memory, uint256[] memory){
        return (musics[_id].donators, musics[_id].trackPrice);
     }

    /**
      // Define a mapping to store the price of each track
     mapping (bytes32 => uint) public trackPrices;

  // Define a function to allow the artist to set the price for their track
  function setTrackPrice(bytes32 trackId, uint price) public {
    trackPrices[trackId] = price;
  } */
}
