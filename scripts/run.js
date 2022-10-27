const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory("Domains");
    const domainContract = await domainContractFactory.deploy();
    await domainContract.deployed();
    console.log("Domain contract deployed to:", domainContract.address);
    console.log("Contract deployed by:", owner.address);

    const txn = await domainContract.register("test");
    await txn.wait();

    const domainOwner = await domainContract.getOwner("test");
    console.log("Domain owner:", domainOwner);

    // Try to set a record with a different owner
    txn = await domainContract.connect(randomPerson).setRecord("test", "HACKED!");
    await txn.wait();
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.error(error);
        process.exit(1);
    }
};

runMain();