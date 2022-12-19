// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract ErrorThrowingContract {
    error CustomError();
    error CustomErrorFrom(uint8 _from);

    function throwCustomError() public {
        revert CustomError();
    }

    function throwsCustomErrorFromOne() public {
        revert CustomErrorFrom(1);
    }

    function throwsCustomErrorFromTwo() public {
        revert CustomErrorFrom(2);
    }
}
