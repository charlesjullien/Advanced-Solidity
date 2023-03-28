const { developmentChains } = require("../helper-hardhat-config")
const { network } = require("hardhat")
const whitelisted = require('../whitelist.json');
const keccak256 = require('keccak256');
const { MerkleTree } = require('merkletreejs');
    
module.exports = async({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    let tab = [];
    whitelisted.map((whitelisted) => {
        tab.push(whitelisted.address);
    })
    const leaves = tab.map((address) => {
        return keccak256(address) // hash the address with keccak256 algo
    })
    let tree = new MerkleTree(leaves, keccak256, { sort: true }); //create a new merkleTree with the leaves and a hash algo (keccak256)
    let merkleTreeRoot = tree.getHexRoot(); // store the tree's root in a variable to send it to contract constructor later

    log("--------------------------------------")
    arguments = [merkleTreeRoot] 
    const MerkleTreeMint = await deploy("MerkleTreeMint", {
        from: deployer,
        args: arguments,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1
    })
}

module.exports.tags = ["all", "MerkleTreeMint", "main"]