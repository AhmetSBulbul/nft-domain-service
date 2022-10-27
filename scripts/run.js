const main = async () => {
    // const [owner, randomPerson] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory("Domains");
    const domainContract = await domainContractFactory.deploy("bulbul");
    await domainContract.deployed();
    console.log("Domain contract deployed to:", domainContract.address);
    // console.log("Contract deployed by:", owner.address);

    let txn = await domainContract.register("ahmets", {value: hre.ethers.utils.parseEther('0.1')});
    await txn.wait();

    const address = await domainContract.getOwner("ahmets");
    console.log("ahmets is owned by:", address);

    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
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