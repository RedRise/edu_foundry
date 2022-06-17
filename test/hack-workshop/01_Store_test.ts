import { expect } from "chai";
import { ethers } from "hardhat";

describe("Store", function () {

  it("Take should return initial amount.", async function () {

    const user = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

    const Store = await ethers.getContractFactory("Store");
    const myStore = await Store.deploy();
    await myStore.deployed();

    const balanceBefore = await ethers.provider.getBalance(user);
    await myStore.store({ value: balanceBefore.div(2) });

    const safe = await myStore.safes(0);
    console.log(safe.owner);
    expect(safe.amount).to.equal(balanceBefore.div(2));

    console.log("Balance 1: " + await ethers.provider.getBalance(user));
    try {
      await myStore.take({ gasLimit: 33126 + 4799 });
    } catch {

    }
    console.log("Balance 2: " + await ethers.provider.getBalance(user));

    // expect(await ethers.provider.getBalance(user)).to.equal(balanceBefore);

  });

  it("", async function () {

  });

});
