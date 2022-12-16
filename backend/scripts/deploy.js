
const hre = require("hardhat");

async function main() {

  const Shopify = await hre.ethers.getContractFactory("Shopify");
  const shopify = await Shopify.deploy();

  await shopify.deployed();

  console.log(
    ` deployed to ${shopify.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
