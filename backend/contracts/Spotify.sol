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

 import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";




contract Spotify is ERC721Enumerable, Ownable{
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
    
 //NFT 
    string _baseTokenURI;

    //  _price is the price of one LW3Punks NFT
    uint256 public _price = 0.01 ether;

    // _paused is used to pause the contract in case of an emergency
    bool public _paused;

 // total number of tokenIds minted
    uint256 public tokenIds;

    modifier onlyWhenNotPaused {
        require(!_paused, "Contract currently paused");
        _;
    }

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

  

    /**
        * @dev ERC721 constructor takes in a `name` and a `symbol` to the token collection.
        * name in our case is `LW3Punks` and symbol is `LW3P`.
        * Constructor for LW3P takes in the baseURI to set _baseTokenURI for the collection.
        */
    constructor (string memory baseURI) ERC721("SpotifyDapp", "spotify") {
        _baseTokenURI = baseURI;
    }

    /**
    * @dev mint allows an user to mint 1 NFT per transaction.
    */
    function mint() public payable onlyWhenNotPaused {
        require(msg.value >= _price, "Ether sent is not correct");
        tokenIds += 1;
        _safeMint(msg.sender, tokenIds); // as parameter takes the tokenId and address.
    }

    /**
    * @dev _baseURI overides the Openzeppelin's ERC721 implementation which by default
    * returned an empty string for the baseURI
    */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    /**
    * @dev tokenURI overides the Openzeppelin's ERC721 implementation for tokenURI function
    * This function returns the URI from where we can extract the metadata for a given tokenId
    */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        // Here it checks if the length of the baseURI is greater than 0, if it is return the baseURI and attach
        // the tokenId and `.json` to it so that it knows the location of the metadata json file for a given
        // tokenId stored on IPFS
        // If baseURI is empty return an empty string
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    /**
    * @dev setPaused makes the contract paused or unpaused
        */
    function setPaused(bool val) public onlyOwner {
        _paused = val;
    }

    /**
    * @dev withdraw sends all the ether in the contract
    * to the owner of the contract
        */
    function withdraw() public onlyOwner  {
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) =  _owner.call{value: amount}("");
        require(sent, "Ether not sent");
    }

        // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

}
