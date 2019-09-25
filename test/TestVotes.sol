pragma solidity ^0.5.8;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EthDemocracy.sol";

contract TestVotes {

    event DebugUint(string _msg, uint _number);
    event DebugAddr(string _msg, address _adr);

    // addresses for mnemonic "scene kite dust inherit sample upset person below fancy drive mean place"
    address[10] voters = [0x617a638B22c1F9FDE234C148289Cf8516c9F47FF, 0x3CaeEDBb4CEAEE2ff16E115835f79b7a5da7e250,
        0x1eb5f605616d941BEa317A9DF61c9677B2e54337, 0x08015CaC790Fb264bD5dfC97877311bAa7845a08,
        0xFb6617A52c3fbdA59ba92b5Ec7A46A93dc4585a1, 0xE2CF3EE4b493EF48f311A7d6F7c911a063817F4C,
        0x57C33F511eeCe8634927e77bDF9C6881e2e83479, 0x10fc828e67d72a1D0e19004E113b7992d983f34E,
        0x8cBC969a11FA9dB1bF69d9C12B26B247Bf438970, 0x7541B5d0268c93d5aBe727c9f55fE693860A5fe4 ];

    function beforeAll() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        ethDemocracy.addVoter(voters[1]);
        ethDemocracy.addVoter(voters[2]);
        ethDemocracy.addVoter(voters[3]);
        ethDemocracy.addVoter(msg.sender);
        ethDemocracy.addVoter(address(this));
    }

    function testMsgSenderInVoters() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        Assert.isTrue(ethDemocracy.isVoter(msg.sender), 'Message.sender should be a voter');
    }

    function testCreateElection() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Test-Election 1');

        uint expected = 1;
        Assert.isTrue(result, 'Result should have been true');
        Assert.equal(ethDemocracy.getVotes(electionId, msg.sender), expected, 'Should be one vote for the msg.sender');
        Assert.equal(ethDemocracy.getVotes(electionId, voters[1]), expected, 'Should be one vote for 0x7D4D...6dfB');
        Assert.equal(ethDemocracy.getVotes(electionId, voters[2]), expected, 'Should be one vote for 0xd36D...FD82');
        Assert.equal(ethDemocracy.getVotes(electionId, voters[3]), expected, 'Should be one vote for 0x9B93...26Af');
    }

    function testCreateElectionOptions() public {
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

    function testExistingVoteWeight() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint expected = 1;
        Assert.equal(ethDemocracy.getVotes(0, voters[1]), expected, 'There should be one vote for 0x7D4D...6dfb');
        Assert.equal(ethDemocracy.getVotes(0, msg.sender), expected, 'There should be one vote for the msg.sender');
    }

    function testNonExistingVoteWeight() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        uint expected = 0;
        Assert.equal(ethDemocracy.getVotes(0, voters[5]), expected, 'There should be no vote');
    }

    function testCastVote() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Neue Bürostadt');

        ethDemocracy.addVoteOption(electionId, 'Hamburg');
        ethDemocracy.addVoteOption(electionId, 'Köln');
        ethDemocracy.addVoteOption(electionId, 'Mannheim');

        uint optionId = ethDemocracy.getVoteOptionId(electionId, 'Hamburg');

        uint currentVotes = ethDemocracy.getResults(electionId, 'Hamburg');
        uint voteWeight = ethDemocracy.getVotes(electionId, address(this));
        uint expected = currentVotes + voteWeight;
        uint expectedVoteWeight = 0;

        Assert.isTrue(ethDemocracy.castVote(electionId, optionId), 'Function call should have succeded');
        Assert.equal(ethDemocracy.getResults(electionId, 'Hamburg'), expected, 'Should be more votes than before');
        Assert.equal(ethDemocracy.getVotes(electionId, address(this)), expectedVoteWeight,
            'Should be no votes left for this address');
    }

    function testGetResults() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Neue Bürostadt');

        ethDemocracy.addVoteOption(electionId, 'Hamburg');
        ethDemocracy.addVoteOption(electionId, 'Köln');
        ethDemocracy.addVoteOption(electionId, 'Mannheim');

        uint optionId = ethDemocracy.getVoteOptionId(electionId, 'Hamburg');

        ethDemocracy.castVote(electionId, optionId);

        Assert.equal(ethDemocracy.getResults(electionId, 'Hamburg'), 1, 'There should be one vote for Hamburg');
        Assert.equal(ethDemocracy.getResults(electionId, 'Köln'), 0, 'There should be no vote for Köln');
        Assert.equal(ethDemocracy.getResults(electionId, 'Mannheim'), 0, 'There should be no vote for Mannheim');
    }

    function testTransferVotes() public {
        EthDemocracy ethDemocracy = EthDemocracy(DeployedAddresses.EthDemocracy());

        address to = voters[2];

        bool result;
        uint electionId;

        (result, electionId) = ethDemocracy.createElection('Test-Election 3');

        uint currentVotesFrom = ethDemocracy.getVotes(electionId, address(this));
        uint currentVotesTo = ethDemocracy.getVotes(electionId, to);

        uint expectedVotesFrom = 0;
        uint expectedVotesTo = currentVotesFrom + currentVotesTo;

        ethDemocracy.transferVotes(electionId, to);

        Assert.equal(ethDemocracy.getVotes(electionId, address(this)), expectedVotesFrom,
            'Should be no votes left for sender');
        Assert.equal(ethDemocracy.getVotes(electionId, to), expectedVotesTo, 'Should be more votes for to');
    }

}
