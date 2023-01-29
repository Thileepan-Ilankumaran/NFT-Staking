const { ethers } = require("hardhat");

async function main() {
  const totalSupply = ethers.utils.parseUnits("1", 8);
  const TOKEN = await ethers.getContractFactory("ThileepToken");
  const token = await TOKEN.deploy(totalSupply);
  await token.deployed();

  console.log("\n Reward Token deployed at", token.address);

  const uri = "dummy uri";
  const NFT = await ethers.getContractFactory("ThileepNFT");
  const nft = await NFT.deploy(uri);
  await nft.deployed();

  console.log("\n NFT deployed at", nft.address);

  const STAKING = await ethers.getContractFactory("staking");
  const staking = await STAKING.deploy(token.address, nft.address);
  await staking.deployed();

  console.log("\n STAKING deployed at \n", staking.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
