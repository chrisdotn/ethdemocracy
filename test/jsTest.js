var EthDemocracy = artifacts.require("./EthDemocracy.sol");

contract('EthDemocracy', function() {
	it("should have zero voters in the beginning", function() {
		return EthDemocracy.deployed().then(function(instance) {
			return instance.getVotersLength();
		}).then(function(voters) {
			assert.equal(voters.valueOf(), 0, "Voters wasn't zero");
		});
	});
	it("is always false", function() {
		return assert.equal(1, 0, "fail");
	});
});