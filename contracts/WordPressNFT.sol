// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Mintable.sol";

library LibPart {
    bytes32 public constant TYPE_HASH = keccak256("Part(address account,uint96 value)");

    struct Part {
        address payable account;
        uint96 value;
    }

    function hash(Part memory part) internal pure returns (bytes32) {
        return keccak256(abi.encode(TYPE_HASH, part.account, part.value));
    }
}

contract OwnableDelegateProxy { }

contract ProxyRegistry {
  mapping(address => OwnableDelegateProxy) public proxies;
}

contract WordPressNFT is ERC721, Mintable {

    //New Marketplace royalty standard
    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;

    /*
     * bytes4(keccak256('getRoyalties(LibAsset.AssetType)')) == 0x44c74bcc
     */
    bytes4 constant _INTERFACE_ID_ROYALTIES = 0x44c74bcc;

    uint96 public royaltyBPS = 500; // 5% royalty on Mainnet

    string private _license = "GPLv2";
    
    string private _baseTokenURI = "https://api.web3wp.com/wapuus/";

    //for OpenSea gas free sale listing
    address proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1; //mainnet

    bool public licenseLocked = false; // Team can't ediit the license after this is flipped
    
    event licenseIsLocked(string _licenseText);

    bool public uriLocked = false; // Team can't ediit the metadata baseURI after this is flipped
    
    event baseURILocked();

    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        address _imx
    ) ERC721(_name, _symbol) Mintable(_owner, _imx) {}

    //for IMX to withdraw NFT to this contract from L2
    function _mintFor(
        address user,
        uint256 id,
        bytes memory
    ) internal override {
        _safeMint(user, id);
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        require(uriLocked == false, "Locked");
        _baseTokenURI = baseURI;
    }

    // Locks the baseURI to prevent further changes 
    function lockBaseURI() public onlyOwner {
        uriLocked = true;
        emit baseURILocked();
    }

    /**
     * @dev Base URI for computing {tokenURI}.
     */
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // Returns the license for tokens
    function tokenLicense(uint256 /*_id*/) public view returns(string memory) {
        return _license;
    }
    
    // Locks the license to prevent further changes 
    function lockLicense() public onlyOwner {
        licenseLocked =  true;
        emit licenseIsLocked(_license);
    }
    
    // Change the license
    function setLicense(string memory license) public onlyOwner {
        require(licenseLocked == false, "Locked");
        _license = license;
    }

    /**
    * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
    */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        // Whitelist OpenSea proxy contract for easy trading.
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }

        return ERC721.isApprovedForAll(owner, operator);
    }
    
    // Change the royaltyBPS
    function setRoyaltyBPS(uint96 newRoyaltyBPS) public onlyOwner {
        require(newRoyaltyBPS != royaltyBPS, "Not new");
        royaltyBPS = newRoyaltyBPS;
    }

    //Rarible royalty interface new
    function getRaribleV2Royalties(uint256 /*id*/) external view returns (LibPart.Part[] memory) {
         LibPart.Part[] memory _royalties = new LibPart.Part[](1);
        _royalties[0].value = royaltyBPS;
        _royalties[0].account = payable(owner());
        return _royalties;
    }

    //Mintable/ERC2981 royalty handler
    function royaltyInfo(uint256 /*_tokenId*/, uint256 _salePrice) external view returns (address receiver, uint256 royaltyAmount) {
       return (owner(), (_salePrice * royaltyBPS)/10000);
    }

    // Register support for our two royalty interface standards.
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        if(interfaceId == _INTERFACE_ID_ROYALTIES) {
            return true;
        }
        if(interfaceId == _INTERFACE_ID_ERC2981) {
            return true;
        }
        return super.supportsInterface(interfaceId);
    }

    //just in case ETH is sent to contract
    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}
