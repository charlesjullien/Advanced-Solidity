Benefits (for a big NFT minting whitelist):
- Allow whitelisted users to mint NFT
- Allow the SC to store all whitelisted users without consuming too much gas.

To use it in our smart contract we use the MerkleProof.sol contract from Openzeppelin :
openzeppelin/contracts/utils/cryptography/MerkleProof.sol

In the frontend, we will have to use merkletreejs to generate our root and proof :
const { MerkleTree } = require('merkletreejs');