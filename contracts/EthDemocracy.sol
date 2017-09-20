pragma solidity ^0.4.15;

contract EthDemocracy {

    struct Election {
        uint id;
        string name;
        string[] options;
        mapping (string => uint) votes;
        mapping (address => uint) balance;
    }

    event Error(string _msg);
    event VoterAdded(address _voter);
    event ElectionCreated(uint _electionId);
    event VoteOptionAdded(uint _electionId, string _option);
    event VoteCast(address _voter, uint _electionId, string _choice);
    event VoteTransferred(address _from, address _to, uint _amount);

    Election[] elections;
    address[] voters;

    /**
     * Return the number of registered voters
     */
    function getVotersLength() constant returns (uint) {
    }

    /**
      * Get the number of elections
      */
    function getElectionsLength() constant returns (uint) {
    }

    /**
     * Test if an address is a registered voter
     */
    function isVoter(address _voter) constant returns (bool) {
    }

    /**
     * Get number of choices for a given election
     */
    function getVoteOptions(uint _electionId) constant returns (uint) {
    }

    /**
     * Get the number of votes that an address can still cast for a given election
     */
    function getVotes(uint _electionId, address _voter) constant returns (uint) {
    }

    /**
     * Get the number of votes for a particular choice in a particular election
     */
    function getResults(uint _electionId, string _option) constant returns (uint) {
    }

    /**
     * Add an address to the registered voters list
     */
    function addVoter(address _voter) returns (bool) {
    }

    /**
     * Clear the list of registered voters
     */
    function deleteVoters() returns (bool) {
    }

    /**
     * Create a new election and distribute one vote to each registered voter. After calling this, the
     * choices still have to be set via `addVoteOption()`
     */
    function createElection(string _name) returns (bool, uint) {
    }

    /**
     * Add a single choice to an election. W/o calling this at least twice, the election is meaningless.
     */
    function addVoteOption(uint _electionId, string _option) returns (bool) {
    }

    /**
     * Vote with all available tokens for a choice
     */
    function castVote(uint _electionId, string _choice) returns (bool) {
    }

    /**
     * Transfer your votes to another address. The address must be a registered voter
     */
    function transferVotes(uint _electionId, uint _amount, address _to) returns (bool) {
    }

}
