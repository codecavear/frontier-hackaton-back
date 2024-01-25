const CoffeToken = artifacts.require("CoffeToken");
require('dotenv').config();
const ethers = require('ethers');

const USDC_ADDRESS = process.env.USDC_ADDRESS;
const MINT_PRICE_IN_WEI = ethers.utils.parseEther("1.5");

module.exports = async function(deployer) {
  // mint price MINT_PRICE_IN_WEI
  await deployer.deploy(CoffeToken, USDC_ADDRESS, MINT_PRICE_IN_WEI.toString());
};
