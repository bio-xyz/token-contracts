// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

import {Token} from "../src/Token.sol";
import {EasyAuctionMock} from "../test/EasyAuctionMock.sol";

contract TokenTest is Test {
    Token internal token;
    EasyAuctionMock internal easyAuction;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address deployer = makeAddr("bighead");
    address minter = makeAddr("minter");

    function setUp() public {
        vm.startPrank(deployer);
        token = new Token("Test Token", "TT");
        token.grantRole(token.MINTER_ROLE(), deployer);
        token.mint(deployer, 100_000_000 ether);
        easyAuction = new EasyAuctionMock(address(token));
        token.transfer(alice, 100 ether);
        token.grantRole(token.MINTER_ROLE(), minter);
        vm.stopPrank();
    }

    function testTokenSupply() public {
        assertEq(token.totalSupply(), 100_000_000 ether);
        assertEq(token.balanceOf(deployer), 99_999_900 ether);
        assertEq(token.balanceOf(alice), 100 ether);
    }

    function testTransfersDisabled() public {
        vm.startPrank(alice);
        vm.expectRevert("ERC20: transfers not enabled");
        token.transfer(bob, 10 ether);
        vm.stopPrank();
    }

    function testTransfersEnabled() public {
        vm.startPrank(deployer);
        token.enableTransfers();
        vm.stopPrank();

        vm.startPrank(alice);
        token.transfer(bob, 10 ether);
        assertEq(token.balanceOf(alice), 90 ether);
        assertEq(token.balanceOf(bob), 10 ether);
        vm.stopPrank();
    }

    function testModeratorCanTransfer() public {
        vm.startPrank(deployer);
        token.grantRole(token.TRANSFER_ROLE(), alice);
        assert(token.hasRole(token.TRANSFER_ROLE(), alice));
        vm.stopPrank();

        vm.startPrank(alice);
        token.transfer(bob, 10 ether);
        assertEq(token.balanceOf(alice), 90 ether);
        assertEq(token.balanceOf(bob), 10 ether);
        vm.stopPrank();
    }

    function testContractCannotTransfer() public {
        vm.startPrank(deployer);
        token.transfer(address(easyAuction), 1 ether);
        vm.stopPrank();

        vm.startPrank(bob);
        vm.expectRevert("ERC20: transfers not enabled");
        easyAuction.transferSomething(bob, 1 ether);
        vm.stopPrank();
    }

    function testModeratorContractCanTransfer() public {
        vm.startPrank(deployer);
        token.grantRole(token.TRANSFER_ROLE(), address(easyAuction));
        token.transfer(address(easyAuction), 1 ether);
        assert(token.hasRole(token.TRANSFER_ROLE(), address(easyAuction)));
        vm.stopPrank();

        vm.startPrank(bob);
        easyAuction.transferSomething(bob, 1 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(address(easyAuction)), 0);
        assertEq(token.balanceOf(bob), 1 ether);
    }

    function testOnlyMinterCanMint() public {
        vm.startPrank(alice);
        vm.expectRevert();
        token.mint(bob, 10 ether);
        vm.stopPrank();

        vm.startPrank(minter);
        token.mint(minter, 10 ether);
        assertEq(token.balanceOf(minter), 10 ether);
        vm.stopPrank();
    }

    function testUnccapedMinting() public {
        vm.startPrank(deployer);
        token.mint(deployer, 100_000_000_000_000 ether);
        assertEq(token.totalSupply(), 100_000_100_000_000 ether);
        vm.stopPrank();
    }
}
