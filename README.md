
# Immutable Contracts

Installation: `npm install @imtbl/contracts`.

| Contract | Public Test (Ropsten) | Production (Mainnet) |
| ------------- |----|----|
| IMX Core | [0x4527be8f31e2ebfbef4fcaddb5a17447b27d2aef](https://ropsten.etherscan.io/address/0x4527be8f31e2ebfbef4fcaddb5a17447b27d2aef) | [0x5FDCCA53617f4d2b9134B29090C87D01058e27e9](https://etherscan.io/address/0x5FDCCA53617f4d2b9134B29090C87D01058e27e9)|

# L2 Minting

Immutable X is the only scaling protocol for NFTs that supports minting assets directly into L2, and having those assets be trustlessly withdrawable to Ethereum L1. To enable this, before you can mint on L2, you need to deploy a L1 contract where these L2-minted assets can be re-minted on L1. Luckily, this is extremely simple: all you need to do is add a hook function to any ERC721 contract to allow Immutable X to mint assets. 

### Basic Usage

If you're starting from scratch, simply deploy a new instance of `Asset.sol` and you'll have an L2-mintable ERC721 contract. Set the `_imx` parameter in the contract constructor to either the `Public Test` or `Production` addresses as above.

If you already have an ERC721 contract written, simply add `Mintable.sol` as an ancestor, implement the `_mintFor` function with your internal mint function, and set up the constructor as above: 

```
import "@imtbl/contracts/Mintable.sol";

contract YourContract is Mintable {

    constructor(address _imx) Mintable(_imx) {}

    function _mintFor(
        address to,
        uint256 id,
        bytes calldata blueprint
    ) internal override {
        // mint the token using your existing implementation
    }

}
```

### Advanced Usage

To enable L2 minting, your contract must implement the `IMintable.sol` interface with a function which mints the corresponding L1 NFT. This function is `mintFor(address to, uint256 id, bytes blueprint)`. The "blueprint" is the immutable metadata set by the minting application at the time of asset creation. This blueprint can store the IPFS hash of the asset, or some of the asset's properties, or anything a minting application deems valuable. You can use a custom implementation of the `mintFor` function to do whatever you like with the blueprint.

```
import "@imtbl/contracts/IMintable.sol";

contract YourContract is IMintable {

    function mintFor(
        address to,
        uint256 id,
        bytes calldata blueprint
    ) external override {
        // TODO: make sure only Immutable X can call this function
        // mint the token!
    }

}
```



