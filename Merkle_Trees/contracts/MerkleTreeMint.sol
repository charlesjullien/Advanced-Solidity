// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ERC721A.sol";

contract MerkleTreeMint is ERC721A, Ownable {

    using Strings for uint;

    bytes32 public merkleRoot;

    uint private constant MAX_SUPPLY = 90;

    constructor(bytes32 _merkleRoot) ERC721A("Merkle Test", "MRKT") {
        merkleRoot = _merkleRoot;
    }

    /// @notice Mint function for the Whitelist phase
    /// @param _account User which will receive the NFT
    /// @param _quantity Amount of NFTs the user wants to mint
    /// @param _proof The merkle proof generated with merkletreejs
    function whitelistMint(address _account, uint _quantity, bytes32[] calldata _proof) external payable {
        require(isWhitelisted(_account, _proof), "You must be whitelisted");
        require(totalSupply() + _quantity <= MAX_SUPPLY, "You cannot mint more than the current supply offers");
        _safeMint(_account, _quantity);
    }

    /// @notice Get the token URI of an NFT by his ID
    /// @param _tokenId The NFT id in the collection linked to metadatas
    /// @return The matching URI (linked to the NFT id)
    function tokenURI(uint _tokenId) public view virtual override(ERC721A) returns(string memory) {
        require(_exists(_tokenId), "URI query for nonexistent token");
        return string(abi.encodePacked("https://bafybeicmeo5go6dv26ddxy4qeca6b6d25aamkw5j7larmdlrjxtohcyc7m.ipfs.nftstorage.link/", _tokenId.toString(), ".json"));
    }

    /// @notice Changes the merkle root (after whitelist update)
    /// @param _merkleRoot the newly generated merkle root
    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
        merkleRoot = _merkleRoot;
    }

    /// @notice Check if an address is whitelisted or not
    /// @notice calls the 'verify' function from 'MerkleProof.sol'
    /// @param _account The user address to check
    /// @param _proof The merkle proof generated with merkletreejs
    /// @return bool return true if the address is whitelisted, false otherwise
    function isWhitelisted(address _account, bytes32[] calldata _proof) internal view returns(bool) {
        return MerkleProof.verify(_proof, merkleRoot, keccak256(abi.encodePacked((_account))));
    }

}