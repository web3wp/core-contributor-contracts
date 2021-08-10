// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./IMX.sol";

contract Registration {
    IMX public imx;

    constructor(IMX _imx) {
        imx = _imx;
    }

    function registerAndDeposit(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        uint256 vaultId
    ) external {
        imx.registerUser(ethKey, starkKey, signature);
        imx.deposit(starkKey, assetType, vaultId);
    }

    function registerAndDeposit(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        uint256 vaultId,
        uint256 quantizedAmount
    ) external {
        imx.registerUser(ethKey, starkKey, signature);
        imx.deposit(starkKey, assetType, vaultId, quantizedAmount);
    }

    function registerAndDepositNft(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        uint256 vaultId,
        uint256 tokenId
    ) external {
        imx.registerUser(ethKey, starkKey, signature);
        imx.depositNft(starkKey, assetType, vaultId, tokenId);
    }

    function registerAndWithdraw(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType
    ) external {
        imx.registerUser(ethKey, starkKey, signature);
        imx.withdraw(starkKey, assetType);
    }

    function registerAndWithdrawTo(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        address recipient
    ) external {
        imx.registerUser(ethKey, starkKey, signature);
        imx.withdrawTo(starkKey, assetType, recipient);
    }

    function registerAndWithdrawNft(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        uint256 tokenId
    ) external {
        imx.registerUser(ethKey, starkKey, signature);
        imx.withdrawNft(starkKey, assetType, tokenId);
    }

    function registerAndWithdrawNftTo(
        address ethKey,
        uint256 starkKey,
        bytes calldata signature,
        uint256 assetType,
        uint256 tokenId,
        address recipient
    ) external {
        imx.registerUser(ethKey, starkKey, signature);
        imx.withdrawNftTo(starkKey, assetType, tokenId, recipient);
    }

    function isRegistered(uint256 starkKey) public view returns (bool) {
        return imx.getEthKey(starkKey) != address(0);
    }
}
