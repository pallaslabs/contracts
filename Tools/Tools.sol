// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

contract Tools {
    bytes4 private constant _INTERFACE_ID_ERC1155 = 0xd9b67a26;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    function isContract(address _addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(_addr)
        }
        return size > 0;
    }

    function isERC721(address _addr) public view returns (bool) {
        if (isContract(_addr)) {
            return IERC165(_addr).supportsInterface(_INTERFACE_ID_ERC721);
        }
        return false;
    }

    function isERC1155(address _addr) public view returns (bool) {
        if (isContract(_addr)) {
            return IERC165(_addr).supportsInterface(_INTERFACE_ID_ERC1155);
        }
        return false;
    }
}