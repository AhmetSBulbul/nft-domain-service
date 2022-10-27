require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.10",
  networks: {
    mumbai: {
      url: process.env.MUMBAI_QUICKNODE_URL,
      accounts: [process.env.TEST_WALLET_PRIVATE_KEY],
    }
  }
};
