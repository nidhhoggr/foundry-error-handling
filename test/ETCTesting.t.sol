// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import "../src/ErrorThrowingContract.sol";

contract ETCTesting is Test {
    ErrorThrowingContract public etcInstance;

    function setUp() public {
        etcInstance = new ErrorThrowingContract();
    }

    function testExpectCustomError() public {
        vm.
        etcInstance.throwsCustomErrorFromOne();
    }

    function testExpectCustomErrorFromOne() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testExpectCustomErrorFromOneUsingAbiDecode() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }
}
