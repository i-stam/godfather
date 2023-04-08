// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {Godfather} from "../src/Godfather.sol";


contract TestGodfather is Test {

    uint256 UNLOCK_TIMESTAMP = 1712560861;

    Godfather vault;
    address godfather;
    address godchild;

    function setUp() public {
        godfather = vm.addr(1);
        vm.label(godfather, "Godfather");

        godchild = vm.addr(1);
        vm.label(godchild, "Godchild");

        vm.prank(godfather);
        vault = new Godfather(UNLOCK_TIMESTAMP);
    }

    function test_Setup() public {
        assertEq(vault.godfather(), godfather);
        assertEq(vault.unlockDate(), UNLOCK_TIMESTAMP);
    }
}
