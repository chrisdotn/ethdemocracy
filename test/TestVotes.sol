pragma solidity ^0.4.5;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthDemocracy.sol";

contract TestVotes {

    event DebugUint(string _msg, uint _number);
    event DebugAddr(string _msg, address _adr);

    function beforeAll() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        ethDemocracy.addVoter(0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB);
        ethDemocracy.addVoter(0xd36D9029f20A288dB9e97E6A1f95b7E0B0B2FD82);
        ethDemocracy.addVoter(0x9B9344069E466E13b17732dd00cE576cee5726Af);
        ethDemocracy.addVoter(msg.sender);
        ethDemocracy.addVoter(address(this));
    }

    function testMsgSenderInVoters() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        Assert.isTrue(ethDemocracy.isVoter(msg.sender), 'Message.sender should be a voter');
    }

    function testNoElectionsInitially() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint expected = 0;
        Assert.equal(ethDemocracy.getElectionsLength(), expected, 'There should no election');
    }

    function testCreateElection() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint electionId = ethDemocracy.createElection('Test-Election 1');

        uint expected = 1;
        Assert.equal(ethDemocracy.getElectionsLength(), expected, 'There should be one election');
        Assert.equal(ethDemocracy.getVotes(electionId, msg.sender), expected, 'There should be one vote for the msg.sender');
        Assert.equal(ethDemocracy.getVotes(electionId, 0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB), expected, 'There should be one vote for 0x7D4D...6dfB');
        Assert.equal(ethDemocracy.getVotes(electionId, 0xd36D9029f20A288dB9e97E6A1f95b7E0B0B2FD82), expected, 'There should be one vote for 0xd36D...FD82');
        Assert.equal(ethDemocracy.getVotes(electionId, 0x9B9344069E466E13b17732dd00cE576cee5726Af), expected, 'There should be one vote for 0x9B93...26Af');
    }

    function testCreateElectionOptions() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint electionId = ethDemocracy.createElection('Test-Election 2');
        ethDemocracy.addVoteOption(electionId, 'A');
        ethDemocracy.addVoteOption(electionId, 'B');
        ethDemocracy.addVoteOption(electionId, 'C');

        uint expected = 3;
        Assert.equal(ethDemocracy.getVoteOptions(electionId), expected, 'There should be three options');
    }

    function testExistingVoteWeight() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint expected = 1;
        Assert.equal(ethDemocracy.getVotes(0, 0x7D4D6943CCDB27bC23740c44A560e6B275AB6dfB), expected, 'There should be one vote for 0x7D4D...6dfb');
        Assert.equal(ethDemocracy.getVotes(0, msg.sender), expected, 'There should be one vote for the msg.sender');
    }

    function testNonExistingVoteWeight() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint expected = 0;
        Assert.equal(ethDemocracy.getVotes(0, 0x43274147984f4d6976b76d06572e4E803356CbC5), expected, 'There should be no vote');
    }

    function testCastVote() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint electionId = ethDemocracy.createElection('Neue Bürostadt');
        ethDemocracy.addVoteOption(electionId, 'Hamburg');
        ethDemocracy.addVoteOption(electionId, 'Köln');
        ethDemocracy.addVoteOption(electionId, 'Mannheim');

        uint currentVotes = ethDemocracy.getResults(electionId, 'Hamburg');
        uint voteWeight = ethDemocracy.getVotes(electionId, address(this));
        uint expected = currentVotes + voteWeight;
        uint expectedVoteWeight = 0;

        Assert.isTrue(ethDemocracy.castVote(electionId, 'Hamburg'), 'Function call should have succeded');
        Assert.equal(ethDemocracy.getResults(electionId, 'Hamburg'), expected, 'There should be more votes than before');
        Assert.equal(ethDemocracy.getVotes(electionId, address(this)), expectedVoteWeight, 'There should be no votes left for this address');
    }

    function testGetResults() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint electionId = ethDemocracy.createElection('Neue Bürostadt');
        ethDemocracy.addVoteOption(electionId, 'Hamburg');
        ethDemocracy.addVoteOption(electionId, 'Köln');
        ethDemocracy.addVoteOption(electionId, 'Mannheim');

        ethDemocracy.castVote(electionId, 'Hamburg');

        Assert.equal(ethDemocracy.getResults(electionId, 'Hamburg'), 1, 'There should be one vote for Hamburg');
        Assert.equal(ethDemocracy.getResults(electionId, 'Köln'), 0, 'There should be no vote for Köln');
        Assert.equal(ethDemocracy.getResults(electionId, 'Mannheim'), 0, 'There should be no vote for Mannheim');
    }

    function testTransferVotes() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        address to = 0xd36D9029f20A288dB9e97E6A1f95b7E0B0B2FD82;

        uint electionId = ethDemocracy.createElection('Test-Election 3');

        uint currentVotesFrom = ethDemocracy.getVotes(electionId, address(this));
        uint currentVotesTo = ethDemocracy.getVotes(electionId, to);

        ethDemocracy.transferVotes(electionId, currentVotesFrom, to);

        uint expectedVotesFrom = 0;
        uint expectedVotesTo = currentVotesFrom + currentVotesTo;

        Assert.equal(ethDemocracy.getVotes(electionId, address(this)), expectedVotesFrom, 'There should be no votes left for sender');
        Assert.equal(ethDemocracy.getVotes(electionId, to), expectedVotesTo, 'There should be more votes for to');
    }

}
