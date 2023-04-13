// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Godfather {

    error NotGodchild(address acount);
    error NotGodfather(address acount);
    error Locked();

    event Received(address, uint256);
    event Withdrawal(address, uint256);
    event NewGodchild(address);

    address immutable public godfather;

    uint256 public unlockDate;
    address payable public godchild;

    constructor(uint256 _unlock) {
        godfather = msg.sender;
        unlockDate = _unlock;
    }

    receive() external payable {
        emit Received(msg.sender, msg.value);
    }

    function withdraw() external {
        if (msg.sender != godchild) {
            revert NotGodchild(msg.sender);
        }
         if (block.timestamp < unlockDate) {
            revert Locked();
        }
        uint256 contractBalance = address(this).balance;
        godchild.transfer(contractBalance);
        emit Withdrawal(msg.sender, contractBalance);
    }

    function setGodchild(address payable _godchild) external {
        if (msg.sender != godfather) {
            revert NotGodfather(msg.sender);
        }
        godchild = _godchild;
        emit NewGodchild(_godchild);
    }
}
