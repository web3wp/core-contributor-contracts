const { expect } = require("chai");

describe("Asset", function () {

  it("Should be able to mint successfully with a valid blueprint", async function () {
   
    const [owner] = await ethers.getSigners();

    const Asset = await ethers.getContractFactory("Asset");

    const o = owner.address;
    const name = 'Gods Unchained';
    const symbol = 'GU';
    const imx = owner.address;
    const mintable = await Asset.deploy(o, name, symbol, imx);

    const tokenID = '1';
    const blueprint = '1000';
    const blob = toHex(`{${tokenID}}:{${blueprint}}`);

    await mintable.mintFor(owner.address, 1, blob);

  });

  it("Should not be able to mint successfully with an invalid blueprint", async function () {
   
    const [owner] = await ethers.getSigners();

    const Asset = await ethers.getContractFactory("Asset");

    const o = owner.address;
    const name = 'Gods Unchained';
    const symbol = 'GU';
    const imx = owner.address;
    const mintable = await Asset.deploy(o, name, symbol, imx);

    const blob = toHex(`:`);
    await expect(mintable.mintFor(owner.address, 1, blob)).to.be.reverted;

  });
});

function toHex(str) {
  let result = '';
  for (let i=0; i < str.length; i++) {
    result += str.charCodeAt(i).toString(16);
  }
  return '0x' + result;
}