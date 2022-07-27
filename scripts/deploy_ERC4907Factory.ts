import { ethers } from "hardhat";

async function main() {
  const ERC4907Upgradeable = await ethers.getContractFactory("ERC4907Upgradeable");

  const _ERC4907Upgradeable = await ERC4907Upgradeable.deploy();

  await _ERC4907Upgradeable.deployed();

  const WrapToERC4907Upgradeable = await ethers.getContractFactory("WrapToERC4907Upgradeable");

  const _WrapToERC4907Upgradeable = await WrapToERC4907Upgradeable.deploy();

  await _WrapToERC4907Upgradeable.deployed();

  const ERC4907Factory = await ethers.getContractFactory('ERC4907Factory');
  const factory = await ERC4907Factory.deploy("0x3569FEBAc68368F7CC8B2Cd01A528e8CbDAdb123", "0x3569FEBAc68368F7CC8B2Cd01A528e8CbDAdb123",_ERC4907Upgradeable.address,_WrapToERC4907Upgradeable.address);
  await factory.deployed();
  console.log("ERC4907Factory deployed to:", factory.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
