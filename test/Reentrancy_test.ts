import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Contract, ContractFactory } from "ethers";
import { ethers } from "hardhat";

describe("Reentrrancy", function () {

  let Feed: ContractFactory;
  let feed: Contract;
  let Consumer: ContractFactory;
  let cons: Contract;
  let owner: SignerWithAddress;

  beforeEach(async function () {
    Feed = await ethers.getContractFactory("InfoFeed");
    feed = await Feed.deploy();
    await feed.deployed();

    Consumer = await ethers.getContractFactory("Consumer");
    cons = await Consumer.deploy();
    await cons.deployed();

    [owner] = await ethers.getSigners();

    // console.log("Owner address: " + owner.address);
    // console.log("Owner balance: " + await ethers.provider.getBalance(owner.address));
  })

  it("Should send wei to consumer contract.", async function () {

    const amount = 1000000000;

    await owner.sendTransaction({
      from: owner.address,
      to: cons.address,
      value: amount
    });

    expect(await ethers.provider.getBalance(cons.address)).to.equal(amount);
  })

  it("Should perform callee calls.", async function () {

    await cons.setFeed(feed.address);

    var result: number;

    result = await cons.callFeed();
    console.log(result);
    expect(result).to.equal(42);

    // should send cash to cons contract
    const amount = 1000000000;
    await owner.sendTransaction({
      to: cons.address,
      value: amount,
    });

    // Cant observe a return value of a state changing function
    // https://ethereum.stackexchange.com/a/109860
    await cons.callPays10();
    expect(await ethers.provider.getBalance(feed.address)).to.equal(10);

    await cons.callPays(11);
    expect(await ethers.provider.getBalance(feed.address)).to.equal(21);
  });

});
