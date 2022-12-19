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

    function _shiftFourBytes(bytes memory reason) internal pure returns (bytes memory data) {
        assembly {data := mload(add(reason, 36))}
    }

    function assertExpectedArgument(bytes memory reason, bytes32 argument) internal {
        bytes32 parsed; 
        assembly {parsed := mload(add(reason, 36))}
        assertEq(argument, parsed);
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

    function testExpectCustomErrorFromOne() public {
        try etcInstance.throwsCustomErrorFromOne() {}
        catch(bytes memory reason) {
            assertExpectedSelector(reason, CustomErrorFrom.selector);
            assertExpectedArgument(reason, bytes32(uint(1)));
        }
    }

    function testExpectCustomErrorFromTwo() public {
        try etcInstance.throwsCustomErrorFromTwo() {}
        catch(bytes memory reason) {
            assertExpectedSelector(reason, CustomErrorFrom.selector);
            assertExpectedArgument(reason, bytes32(uint(2)));
        }
    }

    function testExpectCustomErrorFromParamResultsFromOne() public {
        try etcInstance.throwsCustomErrorFromParam(11) {}
        catch(bytes memory reason) {
            assertExpectedSelector(reason, CustomErrorFrom.selector);
            assertExpectedArgument(reason, bytes32(uint(1)));
        }
    }

    function testExpectCustomErrorFromParamResultsFromTwo() public {
        try etcInstance.throwsCustomErrorFromParam(5) {}
        catch(bytes memory reason) {
            assertExpectedSelector(reason, CustomErrorFrom.selector);
            assertExpectedArgument(reason, bytes32(uint(2)));
        }
    }
}
