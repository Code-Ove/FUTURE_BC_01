// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FutureInternsAdvancedToken} from "../src/FutureInternsAdvancedToken.sol";

/**
 * @title DeployFutureInternsToken
 * @dev Deployment script for FutureInternsAdvancedToken
 */
contract DeployFutureInternsToken is Script {
    struct NetworkConfig {
        address initialHolder;
        uint256 deployerKey;
    }
    
    NetworkConfig public activeNetworkConfig;

    function run() external returns (FutureInternsAdvancedToken) {
        setupNetworkConfig();
        
        vm.startBroadcast(activeNetworkConfig.deployerKey);
        FutureInternsAdvancedToken token = new FutureInternsAdvancedToken(activeNetworkConfig.initialHolder);
        vm.stopBroadcast();
        
        logDeploymentDetails(address(token));
        return token;
    }

    function setupNetworkConfig() internal {


          // PUT YOUR METAMASK ADDRESS HERE


        address initialHolder = ; // Your MetaMask address
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        
        if (block.chainid == 80001) { // Polygon Mumbai
            initialHolder = ; // Your MetaMask
        } else if (block.chainid == 97) { // BSC Testnet
            initialHolder = ; // Your MetaMask
        } else if (block.chainid == 31337) { // Anvil local network
            initialHolder = ; // Your MetaMask
            deployerKey = vm.envOr("PRIVATE_KEY", uint256(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80));
        }
        
        activeNetworkConfig = NetworkConfig(initialHolder, deployerKey);
    }

    function logDeploymentDetails(address tokenAddress) internal view {
        console.log(" Future Interns Token deployed successfully!");
        console.log(" Contract Address:", tokenAddress);
        console.log(" Network ChainID:", block.chainid);
        console.log(" Deployed by:", msg.sender);
        console.log(" Initial Holder:", activeNetworkConfig.initialHolder);
        console.log(" Token Name: Future Interns Token");
        console.log(" Token Symbol: FIT");
        console.log(" Initial Supply: 10,000,000 FIT");
        console.log(" Tokens sent to your MetaMask: ", activeNetworkConfig.initialHolder);
    }
}