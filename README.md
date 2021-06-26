
# Immutable Contracts

Installation: `npm install @imtbl/contracts`.

# L2 Minting

Immutable X is the only scaling protocol for NFTs that supports minting assets directly into L2, and having those assets be trustlessly withdrawable to Ethereum L1. To enable this, before you can mint on L2, you need to deploy a L1 contract where these L2-minted assets can be re-minted on L1. Luckily, this is extremely simple: all you need to do is add a hook function to your smart contract to allow Immutable X to mint assets. 

### Basic Usage

If you're starting from scratch, simply deploy a new instance of `Asset.sol` and you'll have an L2-mintable ERC721 contract.

If you already have an ERC721 contract written, simply add `Mintable.sol` as an ancestor and implemnet the `_mintFor` function: 

```
import "@imtbl/contracts/Mintable.sol";

contract YourContract is Mintable {

    function _mintFor(
        address to,
        uint256 id,
        bytes calldata
    ) internal override {
        // mint the token using your existing implementation
    }

}
```

As `Mintable` calls the `If you have a custom `mint`, `_mint` or `_safeMint` function, 

### Advanced Usage

To enable L2 minting, your contract must implement the `IMintable.sol` interface with a function which mints the corresponding L1 NFT. This function is `mintFor(address to, uint256 id, bytes blueprint)`. The "blueprint" is the immutable metadata set by the minting application at the time of asset creation. This blueprint can store the IPFS hash of the asset, or some of the asset's properties, or anything a minting application deems valuable. You can use a custom implementation of the `mintFor` function to do whatever you like with the blueprint.



