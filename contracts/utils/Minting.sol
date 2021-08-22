// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./String.sol";

library Minting {
    // Split the minting blob into token_id and blueprint portions
    // {token_id}:{blueprint}

    function split(bytes memory blob)
        internal
        pure
        returns (uint256, bytes memory)
    {
        int256 index = String.indexOf(string(blob), ":", 0);
        require(index >= 0, "Separator must exist");
        // Trim the { and } from the parameters
        uint256 tokenID = String.toUint(
            String.substring(blob, 1, uint256(index) - 1)
        );
        bytes memory blueprint = bytes(
            String.substring(blob, uint256(index) + 1, blob.length - 1)
        );
        return (tokenID, blueprint);
    }
}
