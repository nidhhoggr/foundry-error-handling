// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/Vm.sol";
import {ErrorThrowingContract,CustomError,CustomErrorFrom} from "../src/ErrorThrowingContract.sol";

contract ETCTesting is DSTest {
    ErrorThrowingContract internal etcInstance;
    Vm internal immutable vm = Vm(HEVM_ADDRESS);

    function setUp() public {
        etcInstance = new ErrorThrowingContract();
    }

    function assertExpectedSelector(bytes memory reason, bytes32 mSelector) internal {
        bytes4 selector = bytes4(reason);
        assertEq(selector, mSelector);
    }

    function assertExpectedArgument(bytes memory reason, bytes32 argument) internal {
        bytes32 data;
        assembly {data := mload(add(reason, 36))}
        assertEq(argument, data);
    }

    function assertExpectedError(bytes memory reason, bytes32 mSelector, bytes32 argument) internal {
        assertExpectedSelector(reason, mSelector);
        assertExpectedArgument(reason, argument);
    }

    //operator overloading for specific data types
    function assertExpectedArgument(bytes memory reason, uint argument) internal {
        assertExpectedArgument(reason, bytes32(argument));
    }

    function assertExpectedError(bytes memory reason, bytes32 mSelector, uint256 argument) internal {
        assertExpectedError(reason, mSelector, bytes32(argument));
    }

    function testExpectCustomError() public {
        vm.expectRevert(CustomError.selector);
        etcInstance.throwsCustomError();
    }

    function testFailExpectCustomErrorFromOne() public {
        //fails because the argument calldata expected in revert
        //[FAIL. Reason: Error != expected error: 0x25a145180000000000000000000000000000000000000000000000000000000000000001 != 0x25a14518]
        vm.expectRevert(CustomErrorFrom.selector);
        etcInstance.throwsCustomErrorFromOne();
    }

    function testExpectCustomErrorFromOneUsingAbiEncode() public {
        vm.expectRevert(abi.encodePacked(CustomErrorFrom.selector, uint(1)));
        etcInstance.throwsCustomErrorFromOne();
    }

    function testExpectCustomErrorFromOne() public {
        try etcInstance.throwsCustomErrorFromOne() {}
        catch(bytes memory reason) {
            assertExpectedError(reason, CustomErrorFrom.selector, 1);
        }
    }

    function testExpectCustomErrorFromTwo() public {
        try etcInstance.throwsCustomErrorFromTwo() {}
        catch(bytes memory reason) {
            assertExpectedError(reason, CustomErrorFrom.selector, 2);
        }
    }

    function testExpectCustomErrorFromParamResultsFromOne() public {
        try etcInstance.throwsCustomErrorFromParam(11) {}
        catch(bytes memory reason) {
            assertExpectedError(reason, CustomErrorFrom.selector, 1);
        }
    }

    function testExpectCustomErrorFromParamResultsFromTwo() public {
        try etcInstance.throwsCustomErrorFromParam(5) {}
        catch(bytes memory reason) {
            assertExpectedError(reason, CustomErrorFrom.selector, 2);
        }
    }
}
