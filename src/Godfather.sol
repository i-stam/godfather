// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Godfather {

    error Locked();
    error NotGodchild(address account);
    error NotGodfather(address account);

    event Received(address, uint256);
    event Withdrawal(address, uint256);
    event NewGodchild(address);

    address immutable public godfather;
    
    uint256 public unlockDate;
    address payable public godchild;
    string public name;

    constructor(uint256 _unlock, string memory _name) {
        godfather = msg.sender;
        unlockDate = _unlock;
        name = _name;
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
        address payable  _godfather = payable(godfather);
        if (msg.sender != _godfather) {
            revert NotGodfather(msg.sender);
        }
        godchild = _godchild;
        emit NewGodchild(_godchild);
    }
}
