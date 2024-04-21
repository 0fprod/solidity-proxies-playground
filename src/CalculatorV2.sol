// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract CalculatorV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint64 public constant version = 2;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(address initialOwner) public reinitializer(version) {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    function _authorizeUpgrade(address newImplementation) internal override {}

    function add(int256 a, int256 b) public pure returns (int256) {
        return a + b;
    }

    function sub(int256 a, int256 b) public pure returns (int256) {
        return a - b;
    }

    function mul(int256 a, int256 b) public pure returns (int256) {
        return a * b;
    }

    function div(int256 a, int256 b) public pure returns (int256) {
        return a / b;
    }
}
