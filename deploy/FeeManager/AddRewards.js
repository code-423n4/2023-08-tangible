const { upgrades } = require("hardhat");
const { caviarContracts } = require("../addresses");
const { rewardTokens } = require("./rewards");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const caviarFeeManager = await ethers.getContractAt(
    "CaviarFeeManager",
    caviarContracts.FeeManager
  );

  console.log("feeManager address: ", caviarFeeManager.address);

  let tx;

  for (let i = 0; i < rewardTokens.length; i++) {
    tx = await caviarFeeManager.addRewardToken(rewardTokens[i].routes);
    await tx.wait();
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
