module.exports = {
    networks: {
        development: {
            host: "localhost",
            port: 8545,
            network_id: "*", // Match any network id
        }
    },
    solc: {
        optimizer: {
            enabled: true,
            runs: 200,
        }
    },
    mocha: {
    }
};

// Pass reporter as argument to truffle
// To run tests with junit output: truffle test 'mocha-junit-reporter'
let reporterArg = process.argv.indexOf('--reporter')
if (reporterArg >= 0) {
  module.exports['mocha'] = {
    reporter: process.argv[reporterArg + 1]
  }
}
