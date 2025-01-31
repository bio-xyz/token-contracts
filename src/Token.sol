// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20Capped} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {AccessControlDefaultAdminRules} from "@openzeppelin/contracts/access/AccessControlDefaultAdminRules.sol";

contract Token is ERC20, ERC20Burnable, AccessControlDefaultAdminRules {
    bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    bool public transfersEnabled = false;

    constructor(string memory name, string memory symbol)
        ERC20(name, symbol)
        AccessControlDefaultAdminRules(0, msg.sender)
    {}

    function mint(address to, uint256 amount) external onlyRole(MINTER_ROLE) {
        _mint(to, amount);
    }

    // In this implementation this is one-way: once transfers are enabled, they cannot be disabled again
    function enableTransfers() external onlyRole(DEFAULT_ADMIN_ROLE) {
        transfersEnabled = true;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        // Do the following check if transfers are not enabled yet
        if (!transfersEnabled) {
            // from address has to be either the zero address (mint event), the owner or someone with TRANSFER_ROLE
            require(
                from == address(0) || from == owner() || hasRole(TRANSFER_ROLE, from), "ERC20: transfers not enabled"
            );
        }
    }
}
