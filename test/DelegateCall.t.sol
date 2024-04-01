// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import { TargetContract, CallerContract } from "../src/DelegateCall.sol";


contract DelegateCallTest is StdCheats, Test {
    TargetContract target;
    CallerContract caller;
    using stdStorage for StdStorage;


    function setUp() public {
        target = new TargetContract();
        caller = new CallerContract();
    }

    function test_delegatecall() public {
        target.setFoo(42);
        uint fooSlot =  stdstore.target(address(target)).sig("foo()").find();
        uint barSlot =  stdstore.target(address(target)).sig("bar()").find();
        
        assertEq(target.foo(), 42);
        assertEq(target.bar(), 0);
        assertEq(fooSlot, 0);
        assertEq(barSlot, 1);
    }

    function test_delegatecall2() public {
        caller.callTargetSetFeoo(address(target), 42);
        uint fooSlot =  stdstore.target(address(caller)).sig("foo()").find();
        uint barSlot =  stdstore.target(address(caller)).sig("bar()").find();
        
        assertEq(caller.foo(), 0);
        assertEq(caller.bar(), 42);
        assertEq(fooSlot, 1);
        assertEq(barSlot, 0);
    }

}
