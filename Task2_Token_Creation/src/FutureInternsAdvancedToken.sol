// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

/**
 * @title FutureInternsAdvancedToken
 * @dev Code-Over Intern
   @About * Features: Minting, Burning, Freezing Accounts, Pausing Transfers

 */
contract FutureInternsAdvancedToken is ERC20, ERC20Burnable, Ownable, ERC20Permit {
    uint256 private constant INITIAL_SUPPLY = 10_000_000 * 10**18;
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10**18;
    
    mapping(address => bool) private _frozenAccounts;
    
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);
    event AccountFrozen(address indexed account);
    event AccountUnfrozen(address indexed account);

    constructor(address initialHolder) 
        ERC20("Future Interns Token", "FIT") 
        ERC20Permit("Future Interns Token")
    {
        require(initialHolder != address(0), "Invalid initial holder");
        _transferOwnership(initialHolder);
        _mint(initialHolder, INITIAL_SUPPLY);
        emit TokensMinted(initialHolder, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        require(amount > 0, "Amount must be greater than 0");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    function burn(uint256 amount) public override {
        require(!_frozenAccounts[msg.sender], "Account is frozen");
        super.burn(amount);
        emit TokensBurned(msg.sender, amount);
    }

    function burnFrom(address account, uint256 amount) public override {
        require(!_frozenAccounts[account], "Account is frozen");
        require(!_frozenAccounts[msg.sender], "Caller account is frozen");
        super.burnFrom(account, amount);
        emit TokensBurned(account, amount);
    }

    function freezeAccount(address account) external onlyOwner {
        require(account != address(0), "Cannot freeze zero address");
        require(!_frozenAccounts[account], "Account already frozen");
        
        _frozenAccounts[account] = true;
        emit AccountFrozen(account);
    }

    function unfreezeAccount(address account) external onlyOwner {
        require(account != address(0), "Cannot unfreeze zero address");
        require(_frozenAccounts[account], "Account not frozen");
        
        _frozenAccounts[account] = false;
        emit AccountUnfrozen(account);
    }

    function isAccountFrozen(address account) external view returns (bool) {
        return _frozenAccounts[account];
    }

    function transfer(address to, uint256 value) public override returns (bool) {
        require(!_frozenAccounts[msg.sender], "Sender account is frozen");
        require(!_frozenAccounts[to], "Recipient account is frozen");
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public override returns (bool) {
        require(!_frozenAccounts[from], "From account is frozen");
        require(!_frozenAccounts[to], "To account is frozen");
        require(!_frozenAccounts[msg.sender], "Spender account is frozen");
        return super.transferFrom(from, to, value);
    }

    function getTokenInfo() external view returns (
        string memory,
        string memory,
        uint8,
        uint256,
        uint256
    ) {
        return (name(), symbol(), decimals(), totalSupply(), MAX_SUPPLY);
    }
}