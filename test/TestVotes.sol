pragma solidity ^0.4.5;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthDemocracy.sol";

contract TestVotes {

    event DebugUint(string _msg, uint _number);
    event DebugAddr(string _msg, address _adr);

    // addresses from testrpc for mnemonic "yum chocolate"
    // address[10] voters = [0xb731983dE1800A7BC9a760e9889Be73572dE3D36, 0x114fc24cC2CaF4F058262452B96021eD36FE10CC, 0x0c0D6aa95b11bB47Bc43d9592a768453113712F3, 0x43972274180879Af51665864C2c2Cd425a578607, 0xDDE8dc7c42C683da38D0be2a62a8AF9a0accc445, 0x41832d0da4EbF0d7B9d0Bd280d191455B7320be6, 0xa41bcB69236491a1a7c610f9B014bCcf580292C3, 0xb2de2D7E06afbE99eb14746CF48c162742126704, 0x6e203c5060Ff618Bed470740B1Fc47AF50969F3D, 0x4ff202FdbCB19C4be34981110B4c4C10ce9a2a82];

    // addresses for mnemonic "scene kite dust inherit sample upset person below fancy drive mean place"
    address[10] voters = [0x617a638B22c1F9FDE234C148289Cf8516c9F47FF, 0x3CaeEDBb4CEAEE2ff16E115835f79b7a5da7e250, 0x1eb5f605616d941BEa317A9DF61c9677B2e54337, 0x08015CaC790Fb264bD5dfC97877311bAa7845a08, 0xFb6617A52c3fbdA59ba92b5Ec7A46A93dc4585a1, 0xE2CF3EE4b493EF48f311A7d6F7c911a063817F4C, 0x57C33F511eeCe8634927e77bDF9C6881e2e83479, 0x10fc828e67d72a1D0e19004E113b7992d983f34E, 0x8cBC969a11FA9dB1bF69d9C12B26B247Bf438970, 0x7541B5d0268c93d5aBe727c9f55fE693860A5fe4 ];

    function beforeAll() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        ethDemocracy.addVoter(voters[1]);
        ethDemocracy.addVoter(voters[2]);
        ethDemocracy.addVoter(voters[3]);
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

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Test-Election 1');

        uint expected = 1;
        Assert.isTrue(result, 'Result should have been true');
        Assert.equal(ethDemocracy.getElectionsLength(), expected, 'There should be one election');
        Assert.equal(ethDemocracy.getVotes(electionId, msg.sender), expected, 'There should be one vote for the msg.sender');
        Assert.equal(ethDemocracy.getVotes(electionId, voters[1]), expected, 'There should be one vote for 0x7D4D...6dfB');
        Assert.equal(ethDemocracy.getVotes(electionId, voters[2]), expected, 'There should be one vote for 0xd36D...FD82');
        Assert.equal(ethDemocracy.getVotes(electionId, voters[3]), expected, 'There should be one vote for 0x9B93...26Af');
    }

    function testCreateElectionOptions() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Test-Election 2');

        ethDemocracy.addVoteOption(electionId, 'A');
        ethDemocracy.addVoteOption(electionId, 'B');
        ethDemocracy.addVoteOption(electionId, 'C');

        uint expected = 3;
        Assert.equal(ethDemocracy.getVoteOptions(electionId), expected, 'There should be three options');
    }

    function testExistingVoteWeight() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint expected = 1;
        Assert.equal(ethDemocracy.getVotes(0, voters[1]), expected, 'There should be one vote for 0x7D4D...6dfb');
        Assert.equal(ethDemocracy.getVotes(0, msg.sender), expected, 'There should be one vote for the msg.sender');
    }

    function testNonExistingVoteWeight() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint expected = 0;
        Assert.equal(ethDemocracy.getVotes(0, voters[5]), expected, 'There should be no vote');
    }

    function testCastVote() {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Neue Bürostadt');

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

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Neue Bürostadt');

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

        address to = voters[2];

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Test-Election 3');

        uint currentVotesFrom = ethDemocracy.getVotes(electionId, address(this));
        uint currentVotesTo = ethDemocracy.getVotes(electionId, to);

        ethDemocracy.transferVotes(electionId, currentVotesFrom, to);

        uint expectedVotesFrom = 0;
        uint expectedVotesTo = currentVotesFrom + currentVotesTo;

        Assert.equal(ethDemocracy.getVotes(electionId, address(this)), expectedVotesFrom, 'There should be no votes left for sender');
        Assert.equal(ethDemocracy.getVotes(electionId, to), expectedVotesTo, 'There should be more votes for to');
    }

}
