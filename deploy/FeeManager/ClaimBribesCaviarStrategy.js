const { upgrades } = require("hardhat");
const { caviarContracts } = require("../addresses");
const { bribes } = require("./bribes");
const { bribeTokens } = require("../bribesTokens");

async function main() {
  const null_address = "0x0000000000000000000000000000000000000000";
  let tx;

  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const caviarStrategy = await ethers.getContractAt(
    "CaviarStrategy",
    caviarContracts.CaviarStrategy
  );
  
  console.log("caviarStrategy: ", caviarStrategy.address);

  tx = await caviarStrategy.claimBribe(bribes.v628, bribeTokens.v628);

  await tx.wait();

  console.log("claimed: ", tx);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
