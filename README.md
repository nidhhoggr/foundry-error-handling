# foundry-error-handling
Repo to demostrate catching and parsing custom errors in unit tests.


### About

The need for the repo came about to explore convenient ways to conduct foundry unit tests for scenarios that involve the reversion of custom errors containing parameters

```solidity
error MaxTokenAllotment(uint _from);
```

```solidity 
function testExpectCustomErrorWithParam() public {
    try contractInstance.mint{value: 0.1 ether}(1) {}
    catch(bytes memory reason) {
        //assert selector equality
        bytes4 expectedSelector = MaxTokenAllotment.selector;
        bytes4 receivedSelector = bytes4(reason);
        assertEq(expectedSelector, receivedSelector);
        //assert argument equality
        bytes32 parsed; 
        assembly {parsed := mload(add(reason, 36))}
        assertEq(parsed, bytes32(uint(2)));
    }
}
```

### Conclusion
It was found that the most convenient way for unit testing custom errors with deterministic paramaters are the following:

```solidity
function testExpectCustomErrorWithParam() public {
     vm.expectRevert(abi.encodePacked(MaxTokenAllotment.selector, uint(2)));
     contractInstance.mint{value: 0.1 ether}(1);
}
```

Other various helpers have been added to assert custom error selector and paramater equality with comparison operator equality assertion being an eligible candiate for try/catch reason parsing and helper utilization.

### Useful Links
[How Function Selectors Are Computed](https://solidity-by-example.org/function-selector/)

[ABI encode and decode using solidity](https://medium.com/coinmonks/abi-encode-and-decode-using-solidity-2d372a03e110)

[abi.decode does not decode selector](https://github.com/ethereum/solidity/issues/9439)

[Partial matching of custom errors in reverts](https://github.com/foundry-rs/foundry/issues/3725)


