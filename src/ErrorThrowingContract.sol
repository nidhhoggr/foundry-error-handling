// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

error CustomError();
//from paramater alleviates the need to create two seperate errors
//while still explaining a particular error e.g. MaxTokenAllotment
//and can allow test to determine where the error was triggered
error CustomErrorFrom(uint _from);

contract ErrorThrowingContract {
    
    function throwsCustomError() public pure {
        revert CustomError();
    }

    function throwsCustomErrorFromOne() public pure {
        revert CustomErrorFrom(1);
    }

    function throwsCustomErrorFromTwo() public pure {
        revert CustomErrorFrom(2);
    }

    //illustartes a use case where the error paramater becomes useful
    //for testing purposes using static values as parameters
    function throwsCustomErrorFromParam(uint param) public pure {
        if (param > 10) {
            revert CustomErrorFrom(1);
        }
        else {
            revert CustomErrorFrom(2);
        }
    }
}
