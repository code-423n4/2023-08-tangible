const { upgrades } = require("hardhat");

async function main() {
  const null_address = "0x0000000000000000000000000000000000000000";
  const caviarChef_address = "";
  const caviar_address = "";
  let tx;

  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  console.log("\n=== Deploying Caviar Compounder ===");
  const CaviarCompounder = await ethers.getContractFactory(
    "CaviarCompounder"
  );
  const caviarCompounder = await upgrades.deployProxy(CaviarCompounder, [
    "CaviarCompounder",
    caviar_address,
    caviarChef_address
  ]);
  console.log("CaviarCompounder address: ", caviarCompounder.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
