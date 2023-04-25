const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  // Get the contract factory
  const DrugsSupplyChain = await ethers.getContractFactory("DrugsSupplyChain");

  // Deploy the contract
  const drugsSupplyChain = await DrugsSupplyChain.deploy();

  // Wait for the contract to be mined
  await drugsSupplyChain.deployed();

  console.log("DrugsSupplyChain deployed to:", drugsSupplyChain.address);
  fs.writeFileSync("./currentAddress.txt", drugsSupplyChain.address);
}

// Execute the deployment function
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
