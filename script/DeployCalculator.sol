// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {CalculatorV1} from "../src/CalculatorV1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployCalculator is Script {
    function run() external returns (address) {
        address proxy = deployCalculator(address(this));
        return proxy;
    }

    function deployCalculator(address owner) public returns (address) {
        vm.startBroadcast();
        CalculatorV1 calculatorV1 = new CalculatorV1();
        bytes memory data = abi.encodeWithSignature("initialize(address)", owner);
        ERC1967Proxy proxy = new ERC1967Proxy(address(calculatorV1), data);
        vm.stopBroadcast();
        return address(proxy);
    }
}
