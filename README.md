# fundMe_smartContract
It's a simple smart contract written in solidity. In this different eth accounts can fund me using fund() function and i(owner) can withdraw those funds using withdraw function written. 
This smart contract uses chainlink data feeds and aggragraterV3interface to convert user's usd value to ethereum value.
It is using special functions such as receive() and fallback(), if someone tries to send eth without calling fund function then receive will be executed and it will execute fund() function, otherwise fallback().

## how to run in remix
1. Open these two .sol files in remix
2. compile fundMe.sol and connect your wallet using injected web3
3. deploy it and confirm the contract creation fee(testnet network)
4. now for sending eth, fill value section and hit fund
5. if the eth value is lesser than minimum usd value then the transaction will be reverted
6. else it will go through and your data will be stored in funders array and mapping.
