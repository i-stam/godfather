// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Godfather {

    error CannotWithdraw(address);

    event Received(address, uint256);
    event Withdrawal(address, uint256);

    address immutable godfather;

    uint256 unlockDate;
    address payable godchild;

    constructor(address _godfather, uint256 _unlock) {
        godfather = _godfather;
        unlockDate = _unlock;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function withdraw() external {
        if (msg.sender != godchild) {
            revert CannotWithdraw(msg.sender);
        }
        uint256 contractBalance = address(this).balance;
        godchild.transfer(contractBalance);
        emit Withdrawal(msg.sender, contractBalance);
    }

}
