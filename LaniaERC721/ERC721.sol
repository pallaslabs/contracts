//Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract LaniaNFT is ERC721URIStorage, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    event tokenChanged(uint256 tokenId);

    constructor() ERC721("LaniaERC721", "LANIA") {
        _tokenIdCounter.increment();
    }

    function formatTokenURI(string memory _imageURI, string memory _name, string memory _description, string memory _link) internal pure returns (string memory) {
        string memory base = "data:application/json;base64,";
        // string memory _proper;
        // for (uint i = 0; i < _properties.length; ++i) {
        //     if (i == 0)
        //         _proper = string(abi.encodePacked('"', _properties[i], '"'));
        //     else
        //         _proper = string(abi.encodePacked(_proper, ',', '"', _properties[i], '"'));
        // }
        return string(
            abi.encodePacked(
                base,
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "',
                            _name,
                            '", "description": "',
                            _description,
                            '", "external link": "',
                            _link,
                            '", "image": "',
                            _imageURI,
                            '"}'
                        )
                    )
                 )
             )
        );
    }

    function safeMint(address _to, string memory _imageCID, string memory _name, string memory _description, string memory _link) public returns (uint256) {
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(_to, tokenId);
        string memory _imageURI = string.concat("https://ipfs.io/ipfs/", _imageCID);
        _setTokenURI(tokenId, formatTokenURI(_imageURI, _name, _description, _link));
        emit tokenChanged(tokenId);
        _tokenIdCounter.increment();
        return tokenId;
    }

    function withdraw(address payable _to) public onlyOwner() {
        uint256 balance = address(this).balance;
        _to.transfer(balance);
    }

    /// The following functions are overrides required by Solidity for ERC721Enumerable.
    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /// The following functions are overrides required by Solidity for ERC721URIStorage.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}