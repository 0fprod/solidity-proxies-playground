// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import {SmallProxy} from "../src/SmallProxy.sol";

contract ImplementationA {
    uint256 public foo;

    function setFoo(uint256 _foo) public {
        foo = _foo;
    }
}

contract ImplementationB {
    uint256 public foo;

    function setFoo(uint256 _foo) public {
        foo = _foo + 2;
    }
}

contract SmallProxyTest is StdCheats, Test {
    using stdStorage for StdStorage;

    SmallProxy smallProxy;
    ImplementationA versionA;
    ImplementationB versionB;

    function setUp() public {
        smallProxy = new SmallProxy();
        versionA = new ImplementationA();
        versionB = new ImplementationB();
    }

    function test_ImplementationA() public {
        smallProxy.setImplementation(address(versionA));
        bytes memory calldataToExecute = abi.encodeWithSignature("setFoo(uint256)", 42);
        (bool success,) = address(smallProxy).call(calldataToExecute);

        assertTrue(success, "call to smallProxy failed");
        uint256 valueAtStorageSlotZero = smallProxy.readStorage();
        assertEq(valueAtStorageSlotZero, 42);
    }

    function test_ImplementationB() public {
        smallProxy.setImplementation(address(versionB));
        bytes memory calldataToExecute = abi.encodeWithSignature("setFoo(uint256)", 42);
        (bool success,) = address(smallProxy).call(calldataToExecute);

        assertTrue(success, "call to smallProxy failed");
        uint256 valueAtStorageSlotZero = smallProxy.readStorage();
        assertEq(valueAtStorageSlotZero, 44);
    }
}
