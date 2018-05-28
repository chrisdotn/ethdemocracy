// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3 } from 'web3';
import { default as contract } from 'truffle-contract';

// Import our contract artifacts and turn them into usable abstractions.
import ethDemocracy_artifacts from '../../build/contracts/EthDemocracy.json';

// EthDemocracy is our usable abstraction, which we'll use through the code below.
var EthDemocracy = contract(ethDemocracy_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;

window.App = {

    start: function () {
        var self = this;

        // Bootstrap the EthDemocracy abstraction for Use.
        EthDemocracy.setProvider(web3.currentProvider);

        // Get the initial account balance so it can be displayed.
        web3.eth.getAccounts(function (err, accs) {
            if (err != null) {
                alert("There was an error fetching your accounts.");
                return;
            }

            if (accs.length == 0) {
                alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
                return;
            }

            accounts = accs;
            account = accounts[0];

            // register handlers
            $('#addVoter').on('click', () => {
                let address = $('#voter').val();
                self.addVoter(address);
            });

            $('#deleteVoters').on('click', () => {
                self.deleteVoters();
            });

            $('#createElection').on('click', () => {
                let electionName = document.getElementById('electionName').value;
                self.createElection(electionName);
            });

            $('#addVoteOption').on('click', () => {
                let electionId = $('#electionIdOption').val();
                let optionName = $('#optionName').val();
                self.addVoteOption(electionId, optionName);
            });

            $('#vote').on('click', () => {
                let electionId = $('#electionIdVote').val();
                let optionName = $('#optionNameVote').val();

                self.setStatus("Initiating transaction... (please wait)");

                var ethd;
                EthDemocracy.deployed().then(function (instance) {
                    ethd = instance;
                    return ethd.getVoteOptionId(electionId, optionName, {
                        from: account
                    });
                }).then(function (optionId) {
                    console.log('OptionID: ' + optionId);
                    return ethd.castVote(electionId, optionId, {
                        from: account
                    });
                }).then(function () {
                    self.setStatus("Transaction complete!");
                    self.refresh();
                }).catch(function (e) {
                    console.log(e);
                    self.setStatus("Error adding voter; see log.");
                });
            });

            $('#transferVotes').on('click', () => {
                let address = $('#voteTransferAddress').val();
                let electionId = $('#voteTransferElectionId').val();
                self.transferVotes(address, electionId);
            });

            $('#getResults').on('click', () => {
                let electionId = $('#electionIdResult').val();
                let optionId = $('#optionNameResult').val();
                self.getResults(electionId, optionId);
            });

            self.refresh();
        });
    },

    setStatus: function (message) {
        var status = document.getElementById("status");
        status.innerHTML = message;
    },

    refresh: function () {
        let self = this;

        web3.eth.getBalance(account, function (error, result) {
            if (!error) {
                let balance_element = document.getElementById('balance');
                balance_element.innerHTML = web3.fromWei(result, 'ether');
            } else {
                console.error('Couldn\'t get balance; see log.');
            }
        })
    },

    addVoter: function (voter) {
        var self = this;

        this.setStatus("Initiating transaction... (please wait)");

        var ethd;
        EthDemocracy.deployed().then(function (instance) {
            ethd = instance;
            return ethd.addVoter(voter, {
                from: account
            });
        }).then(function () {
            self.setStatus("Transaction complete!");
            self.refresh();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error adding voter; see log.");
        });
    },

    deleteVoters: function () {
        var self = this;
        this.setStatus("Initiating transaction... (please wait)");

        var ethd;
        EthDemocracy.deployed().then(function (instance) {
            ethd = instance;
            return ethd.deleteVoters({
                from: account
            });
        }).then(function () {
            self.setStatus("Transaction complete!");
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error deleting voter; see log.");
        });
    },

    createElection: function (electionName) {
        let self = this;

        this.setStatus("Initiating transaction... (please wait)");

        var ethd;
        EthDemocracy.deployed().then(function (instance) {
            ethd = instance;
            return ethd.createElection(electionName, {
                from: account,
                gas: 1000000
            });
        }).then(function () {
            self.setStatus("Transaction complete!");
            self.refresh();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error creating election; see log.");
        });
    },

    addVoteOption: function (electionId, optionName) {
        let self = this;

        this.setStatus("Initiating transaction... (please wait)");

        var ethd;
        EthDemocracy.deployed().then(function (instance) {
            ethd = instance;
            return ethd.addVoteOption(electionId, optionName, {
                from: account
            });
        }).then(function () {
            self.setStatus("Transaction complete!");
            self.refresh();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error adding vote option; see log.");
        });
    },

    vote: function (electionId, optionId) {
        let self = this;
        this.setStatus("Initiating transaction... (please wait)");

        var ethd;
        EthDemocracy.deployed().then(function (instance) {
            ethd = instance;
            return ethd.vote(electionId, optionId, {
                from: account
            });
        }).then(function () {
            self.setStatus("Transaction complete!");
            self.refresh();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error adding vote option; see log.");
        });
    },

    transferVotes: function (address, electionId) {
        let self = this;
        this.setStatus("Initiating transaction... (please wait)");

        var ethd;
        EthDemocracy.deployed().then(function (instance) {
            ethd = instance;
            return ethd.transferVotes(electionId, address, {
                from: account
            });
        }).then(function () {
            self.setStatus("Transaction complete!");
            self.refresh();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error adding vote option; see log.");
        });
    },

    getResults: function (electionId, optionId) {
        let self = this;
        this.setStatus("Getting Results... (please wait)");

        var ethd;
        EthDemocracy.deployed().then(function (instance) {
            ethd = instance;
            return ethd.getResults.call(electionId, optionId, {
                from: account
            });
        }).then(function (data) {
            self.setStatus("Votes: " + data.toNumber());
            self.refresh();
        }).catch(function (e) {
            console.log(e);
            self.setStatus("Error getting Results; see log.");
        });
    }

};

window.addEventListener('load', function () {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 EthDemocracy, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-ethdmask")
        // Use Mist/MetaMask's provider
        window.web3 = new Web3(web3.currentProvider);
    } else {
        console.warn("No web3 detected. Falling back to http://localhost:8545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-ethdmask");
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    }

    App.start();
});
