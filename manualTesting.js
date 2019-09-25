var ethd;
EthDemocracy.deployed().then(function(instance) {
  return instance.getElectionName(0);
}).then(function(value) {
    console.log(value);
});

var ethd;
EthDemocracy.deployed().then(function(instance) { ethd = instance; });

ethd.addVoter(0x617a638B22c1F9FDE234C148289Cf8516c9F47FF).then(function(result) { console.log(result); }).catch(function(e) { console.error(e);});
ethd.getVotersLength().then(function(res) { console.log(res.valueOf()); });
ethd.deleteVoters().then(function(res) { console.log(res.valueOf()); });

ethd.doStuff1().then(function(res) { console.log(res); });
ethd.doStuff1x().then(function(res) { console.log(res); });


ethd.createElection('Test1', {gas: 1000000}).then(function (result) { console.log(result); }).catch(function (e) { console.error(e); });
ethd.getElectionsLength().then(function (result) { console.log(result.valueOf()); }).catch(function (e) { console.error(e); });
ethd.getElection(0).then(function (result) { console.log(result[1]); })

ethd.addVoteOption(0, 'yellow').then(function (result) { console.log(result); })

ethd.getVoteOption(0, 0).then(function (result) { console.log(result); })

ethd.getVoteOptionId(0, 'red').then(function (result) { console.log(result); })


EthDemocracy.deployed().then(function(instance) { return instance.createElection('Test1'); });

EthDemocracy.deployed().then(function(instance) { return instance.getElectionLength(); }).then(function(value) { console.log(value); });

var allEventsEventsEver = ethd.allEvents({fromBlock: 0, toBlock: 'latest'}, function(error, log){ if (!error) console.log(log); });
var newEvents = ethd.allEvents(function(error, log){ if (!error) console.log(log.event + log.args._msg); });

var errorEvents = ethd.Error(function(error, log){ if (!error) console.log(log.event + ': ' + log.args._msg); });
