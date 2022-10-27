const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory("Domains");
    const domainContract = await domainContractFactory.deploy("bulbul");
    await domainContract.deployed();

    console.log("Domain contract deployed to:", domainContract.address);

    let txn = await domainContract.register("ahmets", {value: hre.ethers.utils.parseEther('0.001')});
    await txn.wait();
    console.log("ahmets.bulbul is owned by:", await domainContract.getOwner("ahmets"));

    txn = await domainContract.setRecord("ahmets", "Decentralized!");
    await txn.wait();
    console.log("Set record for ahmets.bulbul to:", await domainContract.getRecord("ahmets"));

    const owner = await domainContract.getOwner("ahmets");
    console.log("ahmets.bulbul is owned by:", owner);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
}

const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();