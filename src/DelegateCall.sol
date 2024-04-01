// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TargetContract {
    uint public foo;
    uint public bar;

    function setFoo(uint _foo) public {
        foo = _foo;
    }
}


contract CallerContract {
    uint public bar; // 0
    uint public foo; // 1

    function callTargetSetFeoo(address _anotherContract, uint _foo) public {
        (bool s, ) = _anotherContract.delegatecall(
            abi.encodeWithSignature("setFoo(uint256)", _foo)
        );
        require(s,"Not called Called");
    }
}