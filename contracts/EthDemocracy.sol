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
    event VotersDeleted(string _msg);
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
        return voters.length;
    }

    /**
      * Get the number of elections
      */
    function getElectionsLength() constant returns (uint) {
        return elections.length;
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
     * Get number of choices for a given election
     */
    function getVoteOptions(uint _electionId) constant returns (uint) {
        return elections[_electionId].options.length;
    }

    /**
     * Get the number of votes that an address can still cast for a given election
     */
    function getVotes(uint _electionId, address _voter) constant returns (uint) {
        return elections[_electionId].balance[_voter];
    }

    /**
     * Get the number of votes for a particular choice in a particular election
     */
    function getResults(uint _electionId, string _option) constant returns (uint) {
        return elections[_electionId].votes[_option];
    }

    /**
     * Add an address to the registered voters list
     */
    function addVoter(address _voter) returns (bool) {
        if (isVoter(_voter)) { return false; }

        voters.push(_voter);
        VoterAdded(_voter);
        return true;
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
        string[] memory emptyOptions;
        electionId = elections.length;

        elections.push(Election(electionId, _name, emptyOptions));
        for (uint i=0; i<voters.length; i++) {
            elections[elections.length-1].balance[voters[i]] = 1;
        }
        ElectionCreated(elections.length - 1);
        success = true;
    }

    /**
     * Add a single choice to an election. W/o calling this at least twice, the election is meaningless.
     */
    function addVoteOption(uint _electionId, string _option) returns (bool) {
        bytes32 sha3Option = sha3(_option);

        for(uint i=0; i<elections[_electionId].options.length; i++) {
            if (sha3(elections[_electionId].options[i]) == sha3Option) {
                return false;
            }
        }
        elections[_electionId].options.push(_option);
        VoteOptionAdded(_electionId, _option);
        return true;
    }

    /**
     * Vote with all available tokens for a choice
     */
    function castVote(uint _electionId, string _choice) returns (bool) {
        if (_electionId >= elections.length) {
            Error('Errornous election ID');
            return false;
        }

        // votes not cast?
        if (getVotes(_electionId, msg.sender) <= 0) {
            Error('No vote left for msg.sender');
            return false;
        }

        bool validChoice = false;
        bytes32 sha3Choice = sha3(_choice);
        for (uint i=0; i<elections[_electionId].options.length; i++) {
            if (sha3(elections[_electionId].options[i]) == sha3Choice) {
                validChoice = true;
            }
        }

        if (!validChoice) {
            Error('Invalid choice');
            return false;
        }

        uint voteWeight = elections[_electionId].balance[msg.sender];
        elections[_electionId].balance[msg.sender] = 0;
        elections[_electionId].votes[_choice] += voteWeight;
        VoteCast(msg.sender, _electionId, _choice);

        return true;
    }

    /**
     * Transfer your votes to another address. The address must be a registered voter
     */
    function transferVotes(uint _electionId, uint _amount, address _to) returns (bool) {
        if (getVotes(_electionId, msg.sender) < _amount) {
            Error('Not enough votes left');
            return false;
        }

        if (!isVoter(_to)) {
            Error('Receiver is not a voter');
            return false;
        }

        elections[_electionId].balance[msg.sender] -= _amount;
        elections[_electionId].balance[_to] += _amount;
        VoteTransferred(msg.sender, _to, _amount);
        return true;
    }

}
