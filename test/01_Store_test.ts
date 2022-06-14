import { expect } from "chai";
import { ethers } from "hardhat";

describe("Store", function () {

  it("Take should return initial amount.", async function () {

    const user = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";

    const Store = await ethers.getContractFactory("Store");
    const myStore = await Store.deploy();
    await myStore.deployed();

    const balanceBefore = await ethers.provider.getBalance(user);
    await myStore.store({ value: 123 });

    const safe = await myStore.safes(0);
    console.log(safe.owner);
    expect(safe.amount).to.equal(123);

    await myStore.take();
    // expect(await ethers.provider.getBalance(user)).to.equal(balanceBefore);

  });

  it("", async function () {

  });

});
