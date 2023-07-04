// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyERC721 is ERC721 {
    using Strings for uint256;
    string _server = "192.168.3.3:8000";
    string _server_url = string(abi.encodePacked("http://", _server));
    string _base_url = string(abi.encodePacked(_server_url, "/MyNFT/token/"));

    constructor() ERC721("MyPhotoLibrary token", "CQP") {}

    function set_baseurl(string calldata url) public {
        _base_url = url;
    }

    // NFTを新規発行
    function mint(address to, uint256 token_id) public virtual {
        _safeMint(to, token_id);
    }

    function _baseURI() internal view override returns (string memory) {
        return _base_url;
    }


}
