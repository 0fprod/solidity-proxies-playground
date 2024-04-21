// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import {CalculatorV1} from "../src/CalculatorV1.sol";
import {CalculatorV2} from "../src/CalculatorV2.sol";
import {UpgradeCalculator} from "script/UpgradeCalculator.sol";
import {DeployCalculator} from "script/DeployCalculator.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract UUPSProxyTest is StdCheats, Test {
    using stdStorage for StdStorage;

    DeployCalculator deployCalculator;
    UpgradeCalculator upgradeCalculator;
    address owner = makeAddr("owner");

    function setUp() public {
        deployCalculator = new DeployCalculator();
        upgradeCalculator = new UpgradeCalculator();
    }

    function test_CalculatorV1() public {
        address proxy = deployCalculator.deployCalculator(owner);
        int256 add = CalculatorV1(proxy).add(1, 2);
        uint64 version = CalculatorV1(proxy).version();

        assertEq(add, 3);
        assertEq(version, 1);
    }

    function test_Reverts_when_calling_unexisting_fn() public {
        address proxy = deployCalculator.deployCalculator(owner);
        bytes memory calldataToExecute = abi.encodeWithSignature("mul(int256,int256)", [1, 2]);
        (bool sucess,) = address(proxy).call(calldataToExecute);
        assertEq(sucess, false);
    }

    function test_UpgradeCalculator() public {
        CalculatorV2 calculatorV2 = new CalculatorV2();
        address proxy = deployCalculator.deployCalculator(owner);

        address newProxy = upgradeCalculator.upgradeCalculator(proxy, address(calculatorV2), owner);
        int256 mul = CalculatorV2(newProxy).mul(2, 3);
        uint64 newVersion = CalculatorV2(newProxy).version();

        assertEq(mul, 6);
        assertEq(newVersion, 2);
    }
}
