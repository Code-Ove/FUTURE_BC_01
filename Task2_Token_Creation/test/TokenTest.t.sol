// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {FutureInternsAdvancedToken} from "../src/FutureInternsAdvancedToken.sol";

contract FutureInternsTokenTest is Test {
    FutureInternsAdvancedToken public token;
    
    address public owner = address(0x1);
    address public user1 = address(0x2);
    address public user2 = address(0x3);
    address public user3 = address(0x4);
    
    uint256 public constant INITIAL_SUPPLY = 10_000_000 * 10**18;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event AccountFrozen(address indexed account);
    event AccountUnfrozen(address indexed account);

    function setUp() public {
        vm.prank(owner);
        token = new FutureInternsAdvancedToken(owner);
    }

    function test_InitialState() public view {
        (string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals, uint256 currentSupply, uint256 maximumSupply) = token.getTokenInfo();
        
        assertEq(tokenName, "Future Interns Token");
        assertEq(tokenSymbol, "FIT");
        assertEq(tokenDecimals, 18);
        assertEq(currentSupply, INITIAL_SUPPLY);
        assertEq(maximumSupply, 100_000_000 * 10**18);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY);
        assertEq(token.owner(), owner);
    }

    function test_Transfer() public {
        uint256 transferAmount = 100 * 10**18;
        
        vm.prank(owner);
        bool success = token.transfer(user1, transferAmount);
        
        assertTrue(success);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - transferAmount);
        assertEq(token.balanceOf(user1), transferAmount);
    }

    function test_TransferFrom() public {
        uint256 allowanceAmount = 500 * 10**18;
        uint256 transferAmount = 300 * 10**18;
        
        vm.prank(owner);
        bool approveSuccess = token.approve(user1, allowanceAmount);
        assertTrue(approveSuccess);
        
        vm.prank(user1);
        bool transferSuccess = token.transferFrom(owner, user2, transferAmount);
        
        assertTrue(transferSuccess);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - transferAmount);
        assertEq(token.balanceOf(user2), transferAmount);
        assertEq(token.allowance(owner, user1), allowanceAmount - transferAmount);
    }

    function test_Mint() public {
        uint256 mintAmount = 500_000 * 10**18;
        
        vm.prank(owner);
        token.mint(user1, mintAmount);
        
        assertEq(token.balanceOf(user1), mintAmount);
        assertEq(token.totalSupply(), INITIAL_SUPPLY + mintAmount);
    }

    function test_Mint_RevertWhen_NotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        token.mint(user1, 1000);
    }

    function test_Mint_RevertWhen_ExceedsMaxSupply() public {
        uint256 excessAmount = token.MAX_SUPPLY() + 1;
        
        vm.prank(owner);
        vm.expectRevert("Exceeds max supply");
        token.mint(user1, excessAmount);
    }

    function test_Burn() public {
        uint256 burnAmount = 100 * 10**18;
        
        vm.prank(owner);
        token.burn(burnAmount);
        
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - burnAmount);
        assertEq(token.totalSupply(), INITIAL_SUPPLY - burnAmount);
    }

    function test_BurnFrom() public {
        uint256 allowanceAmount = 200 * 10**18;
        uint256 burnAmount = 100 * 10**18;
        
        vm.prank(owner);
        bool approveSuccess = token.approve(user1, allowanceAmount);
        assertTrue(approveSuccess);
        
        vm.prank(user1);
        token.burnFrom(owner, burnAmount);
        
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - burnAmount);
        assertEq(token.allowance(owner, user1), allowanceAmount - burnAmount);
    }

    function test_FreezeAccount() public {
        vm.prank(owner);
        token.freezeAccount(user1);
        
        assertTrue(token.isAccountFrozen(user1));
    }

    function test_FreezeAccount_RevertWhen_NotOwner() public {
        vm.prank(user1);
        vm.expectRevert("Ownable: caller is not the owner");
        token.freezeAccount(user2);
    }

    function test_Transfer_RevertWhen_FrozenSender() public {
        vm.prank(owner);
        token.freezeAccount(user1);
        
        vm.prank(owner);
        bool transferSuccess = token.transfer(user1, 1000);
        assertTrue(transferSuccess);
        
        vm.prank(user1);
        vm.expectRevert("Sender account is frozen");
        // Just call without capturing return values
        address(token).call(
            abi.encodeWithSignature("transfer(address,uint256)", user2, 500)
        );
    }

    function test_Transfer_RevertWhen_FrozenRecipient() public {
        vm.prank(owner);
        token.freezeAccount(user2);
        
        vm.prank(owner);
        vm.expectRevert("Recipient account is frozen");
        // Just call without capturing return values
        address(token).call(
            abi.encodeWithSignature("transfer(address,uint256)", user2, 1000)
        );
    }

    function test_UnfreezeAccount() public {
        vm.prank(owner);
        token.freezeAccount(user1);
        
        vm.prank(owner);
        token.unfreezeAccount(user1);
        
        assertFalse(token.isAccountFrozen(user1));
    }

    function test_Events() public {
        vm.expectEmit(true, true, false, true);
        emit Transfer(owner, user1, 1000);
        
        vm.prank(owner);
        bool transferSuccess = token.transfer(user1, 1000);
        assertTrue(transferSuccess);
        
        vm.expectEmit(true, false, false, true);
        emit TokensMinted(user2, 5000);
        
        vm.prank(owner);
        token.mint(user2, 5000);
        
        vm.expectEmit(true, false, false, true);
        emit TokensBurned(owner, 100);
        
        vm.prank(owner);
        token.burn(100);
        
        vm.expectEmit(true, false, false, true);
        emit AccountFrozen(user3);
        
        vm.prank(owner);
        token.freezeAccount(user3);
        
        vm.expectEmit(true, false, false, true);
        emit AccountUnfrozen(user3);
        
        vm.prank(owner);
        token.unfreezeAccount(user3);
    }

    function test_GetTokenInfo() public view {
        (string memory tokenName, string memory tokenSymbol, uint8 tokenDecimals, uint256 currentSupply, uint256 maximumSupply) = token.getTokenInfo();
        
        assertEq(tokenName, "Future Interns Token");
        assertEq(tokenSymbol, "FIT");
        assertEq(tokenDecimals, 18);
        assertEq(currentSupply, INITIAL_SUPPLY);
        assertEq(maximumSupply, 100_000_000 * 10**18);
    }

    function testFuzz_Transfer(uint256 amount) public {
        amount = bound(amount, 1, token.balanceOf(owner));
        
        vm.prank(owner);
        bool success = token.transfer(user1, amount);
        
        assertTrue(success);
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.balanceOf(owner), INITIAL_SUPPLY - amount);
    }

    function testFuzz_Burn(uint256 amount) public {
        amount = bound(amount, 1, token.balanceOf(owner));
        
        uint256 initialSupply = token.totalSupply();
        uint256 ownerBalance = token.balanceOf(owner);
        
        vm.prank(owner);
        token.burn(amount);
        
        assertEq(token.totalSupply(), initialSupply - amount);
        assertEq(token.balanceOf(owner), ownerBalance - amount);
    }
}