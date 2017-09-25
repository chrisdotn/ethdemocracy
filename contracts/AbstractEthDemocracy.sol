pragma solidity ^0.4.15;

contract AbstractEthDemocracy {

    struct Election {
        uint id;
        string name;
        string[] options;
        mapping (string => uint) votes;
        mapping (address => uint) balance;
    }

    Election[] public elections;
    address[] public voters;

    event Error(string _msg);
    event VoterAdded(address _voter);
    event VotersDeleted(string _msg);
    event ElectionCreated(uint _electionId);
    event VoteOptionAdded(uint _electionId, string _option);
    event VoteCast(address _voter, uint _electionId, string _choice);
    event VoteTransferred(address _from, address _to, uint _amount);

    function getVotersLength() constant returns (uint);
    function getElection(uint _id) constant returns (uint id, string name);
    function getElectionId(string _electionName) constant returns (uint);
    function getElectionName(uint _electionId) constant returns (string);
    function isVoter(address _voter) constant returns (bool);
    function getVoteOption(uint _electionId, uint _optionId) constant returns (string);
    function getVoteOptionId(uint _electionId, string _option) constant returns (uint);
    function getVoteOptions(uint _electionId) constant returns (uint);
    function getVotes(uint _electionId, address _voter) constant returns (uint);
    function getResults(uint _electionId, string _option) constant returns (uint);

    function addVoter(address _voter) returns (bool);
    function deleteVoters() returns (bool);

    function createElection(string _name) returns (bool success, uint electionId);
    function addVoteOption(uint _electionId, string _option) returns (bool);

    function castVote(uint _electionId, uint _optionId) returns (bool);
    function transferVotes(uint _electionId, address _to) returns (bool);
}
