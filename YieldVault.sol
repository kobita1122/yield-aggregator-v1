// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title YieldVault
 * @dev A simplified yield aggregator vault that mints shares for deposits.
 */
contract YieldVault is ERC20, Ownable, ReentrancyGuard {
    IERC20 public immutable underlying;
    address public activeStrategy;

    event Deposit(address indexed user, uint256 amount, uint256 shares);
    event Withdraw(address indexed user, uint256 amount, uint256 shares);
    event StrategyUpdated(address indexed newStrategy);

    constructor(address _underlying, string memory _name, string memory _symbol) 
        ERC20(_name, _symbol) 
        Ownable(msg.sender) 
    {
        underlying = IERC20(_underlying);
    }

    /**
     * @notice Returns the total balance of the underlying asset controlled by the vault.
     */
    function totalAssets() public view returns (uint256) {
        // In a real scenario, this would sum internal balance + balance in strategies
        return underlying.balanceOf(address(this)) + getStrategyBalance();
    }

    /**
     * @notice Deposit underlying tokens and receive vault shares.
     */
    function deposit(uint256 _amount) external nonReentrant {
        uint256 total = totalAssets();
        uint256 shares;

        if (totalSupply() == 0) {
            shares = _amount;
        } else {
            shares = (_amount * totalSupply()) / total;
        }

        require(shares > 0, "Too little shares minted");
        underlying.transferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, shares);

        emit Deposit(msg.sender, _amount, shares);
    }

    /**
     * @notice Withdraw underlying tokens by burning vault shares.
     */
    function withdraw(uint256 _shares) external nonReentrant {
        uint256 amount = (totalAssets() * _shares) / totalSupply();
        _burn(msg.sender, _shares);
        
        // Logic to pull from strategy if internal balance is insufficient
        if (underlying.balanceOf(address(this)) < amount) {
            _withdrawFromStrategy(amount - underlying.balanceOf(address(this)));
        }

        underlying.transfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount, _shares);
    }

    function setStrategy(address _strategy) external onlyOwner {
        activeStrategy = _strategy;
        emit StrategyUpdated(_strategy);
    }

    function getStrategyBalance() public view returns (uint256) {
        if (activeStrategy == address(0)) return 0;
        // Interface call to strategy would go here
        return 0; 
    }

    function _withdrawFromStrategy(uint256 _amount) internal {
        // Internal logic to call strategy's withdraw function
    }
}
