import { expect } from "chai";
import { Bytes, Contract, ContractFactory } from "ethers";
import { ethers } from "hardhat";

describe("05_HeadTail", function () {

  let HeadTail: ContractFactory;
  let HeadTailHack: ContractFactory;
  let game: Contract;
  let hack: Contract;
  let commitment: Bytes[]

  beforeEach(async function () {
    const abiCoder = new ethers.utils.AbiCoder();
    const commitment = ethers.utils.keccak256(abiCoder.encode(["bool", "uint"], [true, 1111]));

    HeadTail = await ethers.getContractFactory("HeadTail");
    game = await HeadTail.deploy(commitment, { value: ethers.utils.parseUnits("1.0", "ether") });

    console.log("After deploy commitment: " + await game.commitmentA())
  });

  it("Should upate parent property", async function () {

    HeadTailHack = await ethers.getContractFactory("HeadTailHack");
    hack = await ethers.getContractAt("HeadTailHack", game.address);
    console.log("hack commitment: " + await hack.commitmentA());
    await hack.close();
  });


});
