require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",

  networks: {
    hardhat: {
      chainId: 31337,
      blockConfirmations: 1,
    },
    ganache: {
      gas: 2100000,
      gasPrice: 8000000000,
      url: "http://127.0.0.1:7545",
      chainId: 1337,
    },
  },
};
