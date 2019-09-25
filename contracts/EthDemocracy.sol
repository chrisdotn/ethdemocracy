pragma solidity ^0.5.8;

import "./AbstractEthDemocracy.sol";

contract EthDemocracy is AbstractEthDemocracy {

    /**
     * Get the number of registered voters
     */
    function getVotersLength() public view returns (uint) {
        return voters.length;
    }

    /**
     * Get the election ID for a given name
     */
    function getElectionId(string memory _electionName) public view returns (uint) {
        for (uint i=0; i<elections.length; i++) {
            if (keccak256(abi.encodePacked(_electionName)) == keccak256(abi.encodePacked(elections[i].name))) {
                return i;
            }
        }
        revert();
    }

    /**
     * Get the name of an election
     */
    function getElectionName(uint _electionId) public view returns (string memory) {
        require(_electionId < elections.length);
        return elections[_electionId].name;
    }

    /**
     * Test if an address is a registered voter
     */
    function isVoter(address _voter) public view returns (bool) {
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
    function getVoteOption(uint _electionId, uint _optionId) public view returns (string memory) {
        require (_electionId < elections.length);
        require (_optionId < elections[_electionId].options.length);

        return elections[_electionId].options[_optionId];
    }

    /**
     * Get the ID of a vote option for a given election and an option's name
     */
    function getVoteOptionId(uint _electionId, string memory _option) public view returns (uint) {
        require(_electionId < elections.length);
        bytes32 hash = keccak256(abi.encodePacked(_option));
        for (uint i=0; i<elections[_electionId].options.length; i++) {
            if (hash == keccak256(abi.encodePacked(elections[_electionId].options[i]))) {
                return i;
            }
        }
        // revert();
        revert('Not a valid option');
    }

    /**
     * Get number of choices for a given election
     */
    function getVoteOptions(uint _electionId) public view returns (uint) {
        require(_electionId < elections.length);
        return elections[_electionId].options.length;
    }

    /**
     * Get the number of votes that an address can still cast for a given election
     */
    function getVotes(uint _electionId, address _voter) public view returns (uint) {
        require(_electionId < elections.length);
        return elections[_electionId].balance[_voter];
    }

    /**
     * Get the number of votes for a particular choice in a particular election
     */
    function getResults(uint _electionId, string memory _option) public view returns (uint) {
        require(_electionId < elections.length);
        return elections[_electionId].votes[_option];
    }

    /**
     * Add an address to the registered voters list
     */
    function addVoter(address _voter) public returns (bool) {
        if (isVoter(_voter)) { return false; }

        voters.push(_voter);
        emit VoterAdded(_voter);
        return true;
    }

    /**
     * Clear the list of registered voters
     */
    function deleteVoters() public returns (bool) {
        voters.length = 0;
        emit VotersDeleted('All voters have been deleted');
        return true;
    }

    /**
     * Create a new election and distribute one vote to each registered voter. After calling this, the
     * choices still have to be set via `addVoteOption()`
     */
    function createElection(string memory _name) public returns (bool success, uint electionId) {
        string[] memory emptyOptions;
        electionId = elections.length;

        elections.push(Election(electionId, _name, emptyOptions));
        for (uint i=0; i<voters.length; i++) {
            elections[elections.length-1].balance[voters[i]] = 1;
        }
        emit ElectionCreated(elections.length - 1);
        success = true;
    }

    /**
     * Add a single choice to an election. W/o calling this at least twice, the election is meaningless.
     */
    function addVoteOption(uint _electionId, string memory _option) public returns (bool) {
        require(_electionId < elections.length);
        bytes32 keccak256Option = keccak256(abi.encodePacked(_option));

        for(uint i=0; i<elections[_electionId].options.length; i++) {
            if (keccak256(abi.encodePacked(elections[_electionId].options[i])) == keccak256Option) {
                return false;
            }
        }
        elections[_electionId].options.push(_option);
        emit VoteOptionAdded(_electionId, _option);
        return true;
    }

    /**
     * Vote with all available tokens for a choice
     */
    function castVote(uint _electionId, uint _optionId) public returns (bool) {
        require (_electionId < elections.length);
        require (_optionId < elections[_electionId].options.length);
        require (getVotes(_electionId, msg.sender) > 0);

        uint voteWeight = elections[_electionId].balance[msg.sender];
        string memory choice = elections[_electionId].options[_optionId];
        elections[_electionId].balance[msg.sender] = 0;
        elections[_electionId].votes[choice] += voteWeight;
        emit VoteCast(msg.sender, _electionId, choice);

        return true;
    }

    /**
     * Transfer your votes to another address. The address must be a registered voter
     */
    function transferVotes(uint _electionId, address _to) public returns (bool) {
        require(_electionId < elections.length);
        require(isVoter(_to));

        uint amount = getVotes(_electionId, msg.sender);

        elections[_electionId].balance[msg.sender] -= amount;
        elections[_electionId].balance[_to] += amount;
        emit VoteTransferred(msg.sender, _to, amount);
        return true;
    }

}
