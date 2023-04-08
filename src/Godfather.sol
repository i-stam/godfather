// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Godfather {

    error CannotWithdraw(address);

    event Received(address, uint256);
    event Withdrawal(address, uint256);

    address immutable public godfather;

    uint256 public unlockDate;
    address payable godchild;

    constructor(uint256 _unlock) {
        godfather = msg.sender;
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
