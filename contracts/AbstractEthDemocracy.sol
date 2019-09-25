pragma solidity ^0.5;

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

    /* Get the number of registered voters */
    function getVotersLength() public view returns (uint);

    /* Get ID of an elections for a name */
    function getElectionId(string memory _electionName) public view returns (uint);

    /* Get ID and name of an elections */
    function getElectionName(uint _electionId) public view returns (string memory);

    /* Check if an address is a registered voter */
    function isVoter(address _voter) public view returns (bool);

    /* Get an option's name for a given election ID and option ID */
    function getVoteOption(uint _electionId, uint _optionId) public view returns (string memory);

    /* Get an option's ID for a given election and an option's name */
    function getVoteOptionId(uint _electionId, string memory _option) public view returns (uint);

    /* Get the number of vote options for a given election */
    function getVoteOptions(uint _electionId) public view returns (uint);

    /* Get the number of remaining votes in an election for a voter */
    function getVotes(uint _electionId, address _voter) public view returns (uint);

    /* Get the number of cast votes for an option in an election */
    function getResults(uint _electionId, string memory _option) public view returns (uint);

    /* Add a voter to the list of registered voters */
    function addVoter(address _voter) public returns (bool);

    /* Delete all voters from the list of registered voters */
    function deleteVoters() public returns (bool);

    /* Create a new election with the given name */
    function createElection(string memory _name) public returns (bool success, uint electionId);

    /* Add an option to an existing election */
    function addVoteOption(uint _electionId, string memory _option) public returns (bool);

    /* cast a vote for an option in an election */
    function castVote(uint _electionId, uint _optionId) public returns (bool);

    /* transfer all own votes in an election to another voter */
    function transferVotes(uint _electionId, address _to) public returns (bool);
}
