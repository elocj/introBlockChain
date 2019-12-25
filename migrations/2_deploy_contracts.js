// Fetch the contract data for RockPaperScissor
var RPS = artifacts.require("./build/contracts/RockPaperScissors.sol");

// JavaScript export
module.exports = function(deployer) {
    // Deployer is the Truffle wrapper for deploying
    // contracts to the network

    // Deploy the contract to the network
    // deployer.deploy(RPS, {gas: 100000000});
    deployer.deploy(RPS);
}
