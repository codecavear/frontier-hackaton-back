const CoffeToken = artifacts.require("CoffeToken");
require("dotenv").config();

const USDC_ADDRESS = process.env.USDC_ADDRESS;
const MINT_PRICE_IN_WEI = web3.utils.toWei("0.1", "ether");
console.log("MINT_PRICE_IN_WEI", MINT_PRICE_IN_WEI);
console.log("USDC_ADDRESS", USDC_ADDRESS) 

module.exports = async function (deployer) {
  await deployer.deploy(CoffeToken, USDC_ADDRESS, MINT_PRICE_IN_WEI.toString());
};
