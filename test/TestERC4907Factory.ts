import { assert, expect } from "chai";
import { ethers } from "hardhat";

describe("test", function () {
    it("Should deploy ERC4907 and WrapToERC4907 contract", async function () {
        /**alice is the Owner */
        const [alice, bob] = await ethers.getSigners();

        const ERC4907Upgradeable = await ethers.getContractFactory("ERC4907Upgradeable");

        const _ERC4907Upgradeable = await ERC4907Upgradeable.deploy();

        const WrapToERC4907Upgradeable = await ethers.getContractFactory("WrapToERC4907Upgradeable");

        const _WrapToERC4907Upgradeable = await WrapToERC4907Upgradeable.deploy();

        const ERC4907Factory = await ethers.getContractFactory("ERC4907Factory");

        const factory = await ERC4907Factory.deploy(alice.address,alice.address,_ERC4907Upgradeable.address,_WrapToERC4907Upgradeable.address);

        let tx = await factory.deployERC4907("T", "T");

        let receipt = await tx.wait();

        console.log(receipt.events[0]);

        const Test721 = await ethers.getContractFactory("Test721");
        let test721 = await Test721.deploy();

        tx = await factory.deployWrapToERC4907("wNFT", "wNFT",test721.address);

        receipt = await tx.wait();

        console.log(receipt.events[0]);

        
    });
});