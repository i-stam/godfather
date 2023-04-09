// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {Godfather} from "../src/Godfather.sol";


contract TestGodfather is Test {

    uint256 UNLOCK_TIMESTAMP = 1712560861;

    Godfather vault;
    address payable godfather;
    address godchild;
    uint256 testAmount = 1e18;

    function setUp() public {
        godfather = address(1);
        vm.label(godfather, "Godfather");
        vm.deal(godfather, testAmount);
        godchild = vm.addr(1);
        vm.label(godchild, "Godchild");

        vm.prank(godfather);
        vault = new Godfather(UNLOCK_TIMESTAMP);
    }

    function test_Setup() public {
        assertEq(vault.godfather(), godfather);
        assertEq(vault.unlockDate(), UNLOCK_TIMESTAMP);
    }

    function test_Receive() public {
        vm.expectEmit(false, false, false, true);
        vm.prank(godfather);
        address(vault).call{value: testAmount}("");
    }
}
