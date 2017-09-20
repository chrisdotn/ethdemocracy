var EthDemocracy = artifacts.require("./EthDemocracy.sol");

module.exports = function(deployer) {
  deployer.deploy(EthDemocracy);
};
