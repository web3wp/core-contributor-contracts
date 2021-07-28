
const { ethers } = require("hardhat");

async function main() {
    const [deployer] = await ethers.getSigners();
  
    console.log("Deploying Contracts with the account:", deployer.address);
    console.log("Account Balance:", (await deployer.getBalance()).toString());

    // Use any logic you want to determine these values
    const owner = process.env.CONTRACT_OWNER_ADDRESS;
    const name = process.env.CONTRACT_NAME;
    const symbol = process.env.CONTRACT_SYMBOL;
  
    // TODO: allow this to be mainnet as well
    await deployAsset(owner, name, symbol, 'ropsten');
}

async function deployAsset(owner, name, symbol, network) {
    const Asset = await ethers.getContractFactory("Asset");
    const imx_address = getIMXAddress(network);
    const asset = await Asset.deploy(owner, name, symbol, imx_address);
  
    console.log("Deployed Contract Address:", asset.address);
}

function getIMXAddress(network) {
    switch (network) {
        case 'ropsten':
            return '0x4527be8f31e2ebfbef4fcaddb5a17447b27d2aef';
        case 'mainnet':
            return '0x5FDCCA53617f4d2b9134B29090C87D01058e27e9';
    }
    throw Error('Invalid network selected')
}

main()
.then(() => process.exit(0))
.catch((error) => {
    console.error(error);
    process.exit(1);
});