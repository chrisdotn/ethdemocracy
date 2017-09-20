pragma solidity ^0.4.5;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthDemocracy.sol";

contract TestVoters {

    function beforeEach() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());
        ethDemocracy.deleteVoters();
    }

  function testInitialNumberOfVoters() {
    EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

    uint expected = 0;
    Assert.equal(ethDemocracy.getVotersLength(), expected, 'There should be no voters initially');
  }

  function testAddVoter() {
      EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

      uint expectedLength = ethDemocracy.getVotersLength() + 1;
      Assert.isTrue(ethDemocracy.addVoter(0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB), 'Voter should have been added');
      Assert.equal(ethDemocracy.getVotersLength(), expectedLength, 'Length should have been increased');
  }

  function testDeleteVoter() {
      EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

      uint expectedLength = 0;
      ethDemocracy.addVoter(0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB);
      Assert.equal(ethDemocracy.deleteVoters(), expectedLength, 'All voters should have been deleted');
  }

  function testAddExistingVoter() {
      EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

      ethDemocracy.addVoter(0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB);

      uint expectedLength = ethDemocracy.getVotersLength();
      Assert.isFalse(ethDemocracy.addVoter(0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB), 'Voter should not have been added');
      Assert.equal(ethDemocracy.getVotersLength(), expectedLength, 'Length should have stayed the same');
  }

  function testAddVoters() {
      EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

      ethDemocracy.addVoter(0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB);
      ethDemocracy.addVoter(0xd36D9029f20A288dB9e97E6A1f95b7E0B0B2FD82);
      ethDemocracy.addVoter(0x9B9344069E466E13b17732dd00cE576cee5726Af);

      uint expected = 3;
      Assert.equal(ethDemocracy.getVotersLength(), expected, 'There should be 3 registered voters');
  }


}
