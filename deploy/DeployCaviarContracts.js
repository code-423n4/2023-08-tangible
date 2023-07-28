const { upgrades } = require("hardhat");

async function main() {
  const null_address = "0x0000000000000000000000000000000000000000";
  const pearl_address = "";
  const vePearl_address = "";
  const pearlVoter_address = "";
  const pearlRewardsDistributor_address =
    "";
  const smartWalletWhitelist_address =
    "";
  const beginTimestamp = "";
  const usdrAddress = "";
  let tx;

  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  console.log("\n=== Deploying SmartWalletWhitelist ===");
  const SmartWalletWhitelist = await ethers.getContractFactory(
    "contracts/SmartWalletWhitelist.sol:SmartWalletWhitelist"
  );
  const smartWalletWhitelist = await SmartWalletWhitelist.deploy(deployer.address);
  console.log("SmartWalletWhitelist address: ", smartWalletWhitelist.address);

  console.log("\n=== Deploying Caviar FeeManager ===");
  const FeeManager = await ethers.getContractFactory(
    "CaviarFeeManager"
  );
  const feeManager = await upgrades.deployProxy(FeeManager, ["CaviarFeeManager"]);
  console.log("FeeManager address: ", feeManager.address);

  console.log("\n=== Deploying Caviar Token ===");
  const Caviar = await ethers.getContractFactory("caviar");
  const caviar = await Caviar.deploy();
  console.log("Caviar address: ", caviar.address);

  console.log("\n=== Deploying CaviarChefRewardSeeder ===");
  const CaviarChefRewardSeeder = await ethers.getContractFactory(
    "CaviarChefRewardSeeder"
  );
  const caviarChefRewardSeeder = await upgrades.deployProxy(
    CaviarChefRewardSeeder,
    ["CaviarChefRewardSeeder", caviar.address]
  );
  console.log(
    "CaviarChefRewardSeeder address: ",
    caviarChefRewardSeeder.address
  );

  console.log("\n=== Deploying CaviarChef ===");
  const CaviarChef = await ethers.getContractFactory(
    "CaviarChef"
  );
  const caviarChef = await upgrades.deployProxy(CaviarChef, [
    "CaviarChef",
    usdrAddress,
    caviar.address,
    caviarChefRewardSeeder.address,
    7 * 86400,
    smartWalletWhitelist_address,
  ]);
  console.log(
    "CaviarChef address: ",
    caviarChef.address
  );

  console.log("\n=== Deploying Caviar Strategy ===");
  const CaviarStrategy = await ethers.getContractFactory("CaviarStrategy");
  const caviarStrategy = await upgrades.deployProxy(CaviarStrategy, [
    "CaviarStrategy",
    pearl_address,
    vePearl_address,
    pearlVoter_address,
    feeManager.address,
    pearlRewardsDistributor_address,
    2
  ]);
  console.log("CaviarStrategy address: ", caviarStrategy.address);

  console.log("\n=== Deploying CaviarManager ===");
  const CaviarManager = await ethers.getContractFactory("CaviarManager");
  const caviarManager = await upgrades.deployProxy(CaviarManager, [
    "CaviarManager",
    caviarStrategy.address,
    caviar.address,
    pearl_address,
    vePearl_address,
    null_address,
    smartWalletWhitelist_address,
    feeManager.address,
    2,
  ]);
  console.log("CaviarManager address: ", caviarManager.address);

  console.log("\n=== Setting CaviarManager to the Strategy ===");
  tx = await caviarStrategy.setCaviarManager(caviarManager.address);
  await tx.wait();
  console.log("done");

  console.log("\n=== Setting CaviarManager to the FeeManager ===");
  tx = await feeManager.setCaviarManager(caviarManager.address);
  await tx.wait();
  console.log("done");

  console.log("\n=== Setting Operator in Caviar token ===");
  tx = await caviar.setOperator(caviarManager.address);
  await tx.wait();
  console.log("done");

  console.log("\n=== Setting BeginTimestamp ===");
  tx = await caviarManager.setBeginTimestamp(beginTimestamp);
  await tx.wait();
  console.log("done");

  console.log("\n=== Setting CaviarChef to the rewardSeeder ===");
  tx = await caviarChefRewardSeeder.setLiveChef(caviarChef.address);
  await tx.wait();
  console.log("done");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
