pragma solidity ^0.5.0; // '0x212D0D278dd883360151A82dc9684465A7Fa358d'

contract Decentragram {
    string public name; // name of the contract
    uint256 public imageCount = 0; // index images

    // store images/posts
    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash; // location at ipfs
        string description; // post description
        uint256 tipAmount; // tip value for post
        address payable author; // address of author to send tip
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    // tip image
    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    constructor() public {
        name = "Decentragram";
    }

    // upload post: store new image in mapping
    function uploadImage(string memory _imgHash, string memory _description)
        public
    {
        // Make sure the image hash exists
        require(bytes(_imgHash).length > 0);

        // Make sure image description exists
        require(bytes(_description).length > 0);

        // Make sure uploader address exists
        require(msg.sender != address(0));

        // Increment image id
        imageCount++;

        // Add Image to the contract
        images[imageCount] = Image(
            imageCount,
            _imgHash,
            _description,
            0,  // tip: initial tip = 0
            msg.sender
        );

        // Trigger an event
        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
    }

    function tipImageOwner(uint256 _id) public payable {
        // Make sure the id is valid
        require(_id > 0 && _id <= imageCount);

        // Fetch the image
        Image memory _image = images[_id];

        // Fetch the author
        address payable _author = _image.author;

        // Pay the author by sending them Ether
        address(_author).transfer(msg.value);

        // Increment the tip amount
        _image.tipAmount = _image.tipAmount + msg.value;

        // Update the image
        images[_id] = _image;
        
        // Trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}