// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {CalculatorV1} from "../src/CalculatorV1.sol";
import {CalculatorV2} from "../src/CalculatorV2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeCalculator is Script {
    function run() external returns (address) {
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        CalculatorV2 newBox = new CalculatorV2();
        vm.stopBroadcast();
        address proxy = upgradeCalculator(mostRecentlyDeployedProxy, address(newBox), address(this));
        return proxy;
    }

    function upgradeCalculator(address proxyAddress, address newImplementation, address owner)
        public
        returns (address)
    {
        vm.startBroadcast();
        CalculatorV1 proxy = CalculatorV1(payable(proxyAddress));
        bytes memory data = abi.encodeWithSignature("initialize(address)", owner);
        proxy.upgradeToAndCall(newImplementation, data);
        vm.stopBroadcast();
        return address(proxy);
    }
}
