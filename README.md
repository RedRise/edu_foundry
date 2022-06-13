# EDU FOUNDRY

## Setup/Install

- https://book.getfoundry.sh/
  - ```curl -L https://foundry.paradigm.xyz | bash```

## Points d'attention

- La compatibilité hardhat est assurée par l'option ```--hh```, voir [project layout](https://book.getfoundry.sh/projects/project-layout.html)

## Journal

-Looking at [WH challenges](https://github.com/QGarchery/hack-smart-contract/blob/master/contracts/SolidityHackingWorkshopV8.sol)
- init gitpod config 
  - curl https://raw.githubusercontent.com/mlgarchery/desplit/master/.gitpod.yml > .gitpod.yml
- configuration [shortcut focus terminal ](https://superuser.com/a/1343695)
- les events de log sont presents dans DSTest forge-std/src/test.sol
- we can test event with vm.expectEmit (see cheatcodes)
