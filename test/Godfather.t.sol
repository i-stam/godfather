// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {Godfather} from "../src/Godfather.sol";


contract TestGodfather is Test {

    event Received(address, uint256);
    event NewGodchild(address);
    event Withdrawal(address, uint256);

    uint256 UNLOCK_TIMESTAMP = 1712560861;

    Godfather vault;
    address payable godfather;
    address payable godchild;
    uint256 testAmount = 1e18;

    function setUp() public {
        godfather = payable(address(1));
        vm.label(godfather, "Godfather");
        vm.deal(godfather, testAmount); //fund account

        godchild = payable(address(2));
        vm.label(godchild, "Godchild");

        vm.prank(godfather);
        vault = new Godfather(UNLOCK_TIMESTAMP, "Dinosauros");
    }

    function test_Setup() public {
        assertEq(vault.godfather(), godfather);
        assertEq(vault.unlockDate(), UNLOCK_TIMESTAMP);
        assertEq(vault.name(), "Dinosauros");
    }

    /*******    Receive     *******/

    function test_Receive() public {
        vm.expectEmit(false, false, false, true);
        vm.prank(godfather);
        payable(vault).transfer(testAmount);
        emit Received(godfather, testAmount);
        assertEq(address(vault).balance, testAmount);
    }

    /*******    Withdraw     *******/

    function test_Withdraw_RevertWhen_NotGodchild() public {
        vm.prank(godfather);
        vm.expectRevert(abi.encodeWithSelector(Godfather.NotGodchild.selector, godfather));
        vault.withdraw();
    }

    function test_Withdraw_RevertWhen_NotUnlocked() public {
        vm.prank(godfather);
        vault.setGodchild(godchild);
        vm.prank(godchild);
        vm.expectRevert(abi.encodeWithSelector(Godfather.Locked.selector));
        vault.withdraw();
    }

    function test_Withdraw() public {
        vm.startPrank(godfather);
        vault.setGodchild(godchild);
        payable(vault).transfer(testAmount);
        vm.stopPrank();
        vm.expectEmit(false, false, false, true);
        emit Withdrawal(godchild, testAmount);
        vm.warp(UNLOCK_TIMESTAMP);
        vm.prank(godchild);
        vault.withdraw();
        assertEq(godchild.balance, testAmount);
    }

    /*******    SetGodchild     *******/

    function test_SetGodchild_RevertWhen_SenderNotGodfather() public {
        vm.prank(godchild);
        vm.expectRevert(abi.encodeWithSelector(Godfather.NotGodfather.selector, godchild));
        vault.setGodchild(godchild);
    }
    
    function test_SetGodchild() public {
        vm.prank(godfather);
        vm.expectEmit(false, false, false, true);
        emit NewGodchild(godchild);
        vault.setGodchild(godchild);
        assertEq(vault.godchild(), godchild);
    }

}
