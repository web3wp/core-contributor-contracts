// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Mintable.sol";

contract Asset is ERC721, Mintable {
    address public imx;
    mapping(uint256 => bytes) public blueprints;

    event AssetMinted(address to, uint256 id, bytes blueprint);

    constructor(
        string memory _name,
        string memory _symbol,
        address _imx
    ) ERC721(_name, _symbol) {
        imx = _imx;
    }

    modifier onlyIMX {
        require(msg.sender == imx, "Function can only be called by IMX");
        _;
    }

    function mintFor(
        address to,
        uint256 id,
        bytes calldata blueprint
    ) external override onlyIMX {
        _safeMint(to, id);
        blueprints[id] = blueprint;
        emit AssetMinted(to, id, blueprint);
    }
}
