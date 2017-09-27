# EthDemocracy
This project is an unfinished smart contract for Ethereum that is used in trainings.

[![CircleCI](https://circleci.com/gh/chrisdotn/ethdemocracy/tree/master.svg?style=svg)](https://circleci.com/gh/chrisdotn/ethdemocracy/tree/master)

## Use Case
The project provides a stub for a smart contract that implements a simple _liquid democracy_ on the blockchain. The projects supplies tests for the stub that all fail initially. During the training we want to actually implement the contract so that the tests all succeed.

## Installation
To use the project, clone the repository:
```sh
git clone git://github.com/chrisdotn/ethdemocracy.git
```
or one of the supplied URLs by Github.

Change into the directory and do a
```sh
npm install
```


## Usage
To develop with the project make sure to have [testrpc](https://github.com/ethereumjs/testrpc) running.

After all packages have installed you can use the [truffle](https://www.truffleframework.com) commands to interact with the project:
- `truffle compile` will compile all smart contracts.
- `truffle migrate` will compile smart contracts and deploy them to the default network.
- `truffle compile --network staging` will compile and deploy to network staging.
- `truffle compile --reset` will compile and deploy all smart contract even if they haven't changed.
- `truffle test` will run the tests in directory `$(PROJECT)/test`.

To interact with the frontend use:
- `npm run build` build the frontend using webpack
- `npm run dev` build the frontend using webpack and serve it to `localhost:8080`. This command will monitor changes to the frontend and redeploy if needed.
