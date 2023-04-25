const { ethers } = require("hardhat");
const fs = require("fs");

async function main() {
  const address = fs.readFileSync("./currentAddress.txt").toString();
  // Get the deployed contract
  const DrugsSupplyChain = await ethers.getContractFactory("DrugsSupplyChain");
  const drugsSupplyChain = await DrugsSupplyChain.attach(address); // Replace with your contract address

  // Add drugs
  await drugsSupplyChain.addDrug(1, "Drug1", "Manufacturer1", 100, 100); // Example drug with expiry date of 30-Apr-2023 and quantity of 100
  await drugsSupplyChain.addDrug(2, "Drug2", "Manufacturer2", 2, 50); // Example drug with expiry date of 15-Jun-2023 and quantity of 50

  console.log("added drugs");

  const drugCount = await drugsSupplyChain.getDrugCount();

  console.log(drugCount.toNumber());
  // Check expiry status
  await drugsSupplyChain.checkExpiry();
  //   console.log(check);

  //   // Get expired drugs
  const [expiredDrugIds, expiredItemCount] =
    await drugsSupplyChain.getExpiredItems();
  console.log("Expired Drug IDs:", expiredDrugIds);
  console.log("Expired Item Count:", expiredItemCount.toNumber());

  //   const allDrugs = await drugsSupplyChain.getDrugs(1);
  //   console.log("Drugs:", allDrugs);

  //   // Get all transactions
  //   const allTransactions = await drugsSupplyChain.getTransactions();
  //   console.log("All Transactions:", allTransactions);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
