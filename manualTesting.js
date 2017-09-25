var ethd;
EthDemocracy.deployed().then(function(instance) {
  return instance.getElectionName(0);
}).then(function(value) {
    console.log(value);
});

var ethd;
EthDemocracy.deployed().then(function(instance) { ethd = instance; });

ethd.createElection('Test1', {gas: 1000000}).then(function (result) { console.log(result); }).catch(function (e) { console.error(e); });
ethd.getElectionsLength().then(function (result) { console.log(result.valueOf()); }).catch(function (e) { console.error(e); });
ethd.getElection(0).then(function (result) { console.log(result[1]); })

ethd.addVoteOption(0, 'yellow').then(function (result) { console.log(result); })

ethd.getVoteOption(0, 0).then(function (result) { console.log(result); })

ethd.getVoteOptionId(0, 'red').then(function (result) { console.log(result); })


EthDemocracy.deployed().then(function(instance) { return .createElection('Test1'); });

EthDemocracy.deployed().then(function(instance) { return instance.getElectionLength(); }).then(function(value) { console.log(value); });
