const { upgrades } = require("hardhat");
const { caviarContracts } = require("../addresses");

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

  tx = await caviarFeeManager.notifyRewards();
  console.log("Notified rewards");

  // tx = await caviarFeeManager.swapToCaviar(
  //   "0xe80772Eaf6e2E18B651F160Bc9158b2A5caFCA65"
  // );
  await tx.wait();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
