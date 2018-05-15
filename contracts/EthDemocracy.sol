pragma solidity ^0.4.15;

import "./AbstractEthDemocracy.sol";

contract EthDemocracy is AbstractEthDemocracy {

    /**
     * Get the number of registered voters
     */
    function getVotersLength() constant returns (uint) {
        return voters.length;
    }

    /**
     * Get the election ID for a given name
     */
    function getElectionId(string _electionName) constant returns (uint) {
        for (uint i=0; i<elections.length; i++) {
            if (sha3(_electionName) == sha3(elections[i].name)) {
                return i;
            }
        }
        revert();
    }

    /**
     * Get the name of an election
     */
    function getElectionName(uint _electionId) constant returns (string) {
        require(_electionId < elections.length);
        return elections[_electionId].name;
    }

    /**
     * Test if an address is a registered voter
     */
    function isVoter(address _voter) constant returns (bool) {
        for (uint i=0; i<voters.length; i++) {
            if (_voter == voters[i]) {
                return true;
            }
        }
        return false;
    }

    /**
     * Get the name of a vote option for a given election ID and option ID
     */
    function getVoteOption(uint _electionId, uint _optionId) constant returns (string) {
        require (_electionId < elections.length);
        require (_optionId < elections[_electionId].options.length);

        return elections[_electionId].options[_optionId];
    }

    /**
     * Get the ID of a vote option for a given election and an option's name
     */
    function getVoteOptionId(uint _electionId, string _option) constant returns (uint) {
        require(_electionId < elections.length);
        var hash = sha3(_option);
        for (uint i=0; i<elections[_electionId].options.length; i++) {
            if (hash == sha3(elections[_electionId].options[i])) {
                return i;
            }
        }
        revert();
        //revert('Not a valid option');
    }

    /**
     * Get number of choices for a given election
     */
    function getVoteOptions(uint _electionId) constant returns (uint) {
        require(_electionId < elections.length);
        return elections[_electionId].options.length;
    }

    /**
     * Get the number of votes that an address can still cast for a given election
     */
    function getVotes(uint _electionId, address _voter) constant returns (uint) {
        require(_electionId < elections.length);
        return elections[_electionId].balance[_voter];
    }

    /**
     * Get the number of votes for a particular choice in a particular election
     */
    function getResults(uint _electionId, string _option) constant returns (uint) {
        require(_electionId < elections.length);
        return elections[_electionId].votes[_option];
    }

    /**
     * Add an address to the registered voters list
     */
    function addVoter(address _voter) returns (bool) {
        // TODO
    }

    /**
     * Clear the list of registered voters
     */
    function deleteVoters() returns (bool) {
        voters.length = 0;
        VotersDeleted('All voters have been deleted');
        return true;
    }

    /**
     * Create a new election and distribute one vote to each registered voter. After calling this, the
     * choices still have to be set via `addVoteOption()`
     */
    function createElection(string _name) returns (bool success, uint electionId) {
        // TODO
    }

    /**
     * Add a single choice to an election. W/o calling this at least twice, the election is meaningless.
     */
    function addVoteOption(uint _electionId, string _option) returns (bool) {
        // TODO
    }

    /**
     * Vote with all available tokens for a choice
     */
    function castVote(uint _electionId, uint _optionId) returns (bool) {
        require (_electionId < elections.length);
        require (_optionId < elections[_electionId].options.length);
        require (getVotes(_electionId, msg.sender) > 0);

        uint voteWeight = elections[_electionId].balance[msg.sender];
        string memory choice = elections[_electionId].options[_optionId];
        elections[_electionId].balance[msg.sender] = 0;
        elections[_electionId].votes[choice] += voteWeight;
        VoteCast(msg.sender, _electionId, choice);

        return true;
    }

    /**
     * Transfer your votes to another address. The address must be a registered voter
     */
    function transferVotes(uint _electionId, address _to) returns (bool) {
        // TODO
    }

}
