const CoffToken = artifacts.require("CoffToken");
/* const MockUsdc = artifacts.require("MockUsdc");
 */
module.exports = async function (deployer) {
    /* await deployer.deploy(MockUsdc);
    const mockUsdcInstance = await MockUsdc.deployed(); */

    const MINT_PRICE_IN_WEI = "1000000000000000000";
    await deployer.deploy(CoffToken, mockUsdcInstance.address || process.env.ERC20_ADDRESS , MINT_PRICE_IN_WEI);
};
