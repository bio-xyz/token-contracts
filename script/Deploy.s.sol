// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Token} from "../src/Token.sol";

contract DeploymentScript is Script {
    address public multiSigAddress;
    address public tokenAddress;

    string public tokenName;
    string public tokenSymbol;

    uint256 public deployerPrivateKey;

    // Initialize in constructor
    constructor() {
        multiSigAddress = vm.envAddress("MULTISIG_ADDRESS");
        tokenAddress = vm.envAddress("TOKEN_ADDRESS");

        tokenName = vm.envString("TOKEN_NAME");
        tokenSymbol = vm.envString("TOKEN_SYMBOL");

        deployerPrivateKey = vm.envUint("PRIVATE_KEY_DEPLOYER_PROD");
    }
}

// Contract for deploying the token
contract DeployToken is DeploymentScript {
    error TokenDeploymentFailed();

    function run() public {
        vm.startBroadcast(deployerPrivateKey);
        address deployerAddress = vm.addr(deployerPrivateKey);

        console.log("Deployer address: %s", deployerAddress);
        console.log("MultiSig address: %s", multiSigAddress);
        console.log("Token name: %s", tokenName);
        console.log("Token symbol: %s", tokenSymbol);

        require(bytes(tokenName).length > 0, "Invalid token name");
        require(bytes(tokenSymbol).length > 0, "Invalid token symbol");
        require(multiSigAddress != address(0), "Invalid multiSig address");

        Token token = new Token(tokenName, tokenSymbol);

        if (address(token) == address(0)) {
            revert TokenDeploymentFailed();
        }

        // Setup initial roles
        // Grant MINTER_ROLE to multisig
        token.grantRole(token.MINTER_ROLE(), multiSigAddress);
        // Grant TRANSFER_ROLE to multisig
        token.grantRole(token.TRANSFER_ROLE(), multiSigAddress);

        // Begin transfer of admin role to multisig
        token.beginDefaultAdminTransfer(multiSigAddress);

        console.log("Token deployed successfully at: %s", address(token));
        console.log("Roles granted to multisig");
        console.log("Admin transfer to multisig initiated");

        vm.stopBroadcast();
    }
}
