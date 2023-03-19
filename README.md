# EDUCATIONAL FOUNDRY REPO

## Installation

- [Git submodules](https://newbedev.com/pull-git-submodules-after-cloning-project-from-github)
  1. ```git submodule update --init```
  2. ```git pull --recurse-submodules```
  3. ```git submodule update --init --recursive```
- https://book.getfoundry.sh/
  - ```curl -L https://foundry.paradigm.xyz | bash```
- ```npm install```

## Steps followed to setup this repo

- Install Foundry
- [Install Hardhat](https://book.getfoundry.sh/config/hardhat.html)
- Init Hardhat
- Setup Hardhat typescript compatibility
- Install Hardhat add-ins

## Resources / References

- [References](https://github.com/crisgarner/awesome-foundry)
- Looking at [WH challenges]()
<<<<<<< HEAD
- https://github.com/sigp/solidity-security-blog
=======
- https://docs.avax.network/dapps/smart-contracts/using-foundry-with-the-avalanche-c-chain
- https://github.com/nicolasgarcia214/damn-vulnerable-defi-foundry
>>>>>>> 6702afd3d2b9646d77f615b7658992ad4784e446

## Content

### [Hack Workshop](https://github.com/QGarchery/hack-smart-contract/blob/master/contracts/SolidityHackingWorkshopV8.sol)

1. ```Store.sol``` in progress
2. ```02_Discounted.t.sol``` OK
3. ```03_HeadOrTail.t.sol``` OK
4. ```04_Vault.t.sol``` OK

### General Tests

- ```CallerCallee.sol```: implements a ```Caller``` contract that calls a ``Callee`` contract (tests: Foundry & Hardhat).
- ```Reentancy.sol``` : implements a ```VulnerableVault``` with various ways to withdraw funds (transfer, send, call) and re-entrancy pattern vulnerability (tests: Foundry).



## TODO

- receive vs fallback
- revert / out of gas
- on Coffers, automatic getter of public struct{ uint, mapping} only returns uint
- What does forge update do? https://github.com/foundry-rs/foundry/issues/3720