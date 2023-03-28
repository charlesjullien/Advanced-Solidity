import whitelisted from './whitelist.json'
import { MerkleTree } from "merkletreejs";
import keccak256 from "keccak256";

const mint = async () => {
    let tab = [];
    whitelisted.map((account) => {
        tab.push(account.address); // store the whitelisted addresses from the whitelist.json in an array
    });
    let leaves = tab.map((address) => keccak256(address)); // address : connected user's address
    let tree = new MerkleTree(leaves, keccak256, { sort: true }); // create a new merkleTree with the leaves and a hash algo (keccak256)
    let leaf = keccak256(address); // stores the user's address as a leaf
    let proof = tree.getHexProof(leaf); // stores the proof for a targeted leaf as hex string

	// call contract (previously declared with ethers js in a real frontend) mint function with those params.
	let mint = await contract.whitelistMint(address, quantity, proof);
	await mint.wait();
}