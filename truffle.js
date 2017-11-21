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
    // Uncomment this if you want XML test reports, leave as is for console output
    /*
    mocha: {
       reporter: 'mocha-junit-reporter'
    }
    */
};
