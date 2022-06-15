// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { BigNumber } from "ethers";
import hre from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const user = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
  // We get the contract to deploy
  const Store = await hre.ethers.getContractFactory("Store");
  const myStore = await Store.deploy();
  await myStore.deployed();

  const balanceBefore = await hre.ethers.provider.getBalance(user);
  console.log(balanceBefore);

  await myStore.store({ value: hre.ethers.utils.parseEther('1') });
  var safe = await myStore.safes(0);
  console.log(safe.owner);
  console.log(safe.amount);

  var balanceAfter: BigNumber;
  balanceAfter = await hre.ethers.provider.getBalance(user);
  console.log("Balance lost post deploy: " + balanceBefore.sub(balanceAfter));

  // https://growingdata.com.au/how-to-calculate-gas-fees-on-ethereum/
  try {
    // 33126
    const tx = await myStore.take({ gasLimit: 37535 + 4799 });
    const receipt = await tx.wait();
    const gasUsed = BigInt(receipt.cumulativeGasUsed);
    console.log(gasUsed);
    console.log("ok take");
  } catch (error) {
    console.log("error take");
  }

  balanceAfter = await hre.ethers.provider.getBalance(user);
  console.log("Balance Gain post take x1: " + balanceAfter.sub(balanceBefore));

  safe = await myStore.safes(0);
  console.log("Amount in Store after failed take: " + safe.amount);

  await myStore.take();
  balanceAfter = await hre.ethers.provider.getBalance(user);
  console.log("Balance Gain post take x2: " + balanceAfter.sub(balanceBefore));

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
