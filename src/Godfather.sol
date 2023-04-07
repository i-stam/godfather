// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Godfather {

    event Received(address, uint256);

    address immutable godfather;

    uint256 unlockDate;
    address godchild;

    constructor(address _godfather, uint256 _unlock) {
        godfather = _godfather;
        unlockDate = _unlock;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

}
