// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";

contract Pool {
    IERC20 public usdc;
    ILendingPool public lendingPool;
    mapping(address => uint256) public deposits;

    constructor(address _usdc, address _lendingPool) public {
        usdc = IERC20(_usdc);
        lendingPool = ILendingPool(_lendingPool);
    }

    function deposit(uint256 amount) external {
        usdc.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(deposits[msg.sender] >= amount, "Insufficient balance");
        deposits[msg.sender] -= amount;
        usdc.transfer(msg.sender, amount);
    }

    function depositToAave() external {
        uint256 amount = usdc.balanceOf(address(this));
        usdc.approve(address(lendingPool), amount);
        lendingPool.deposit(address(usdc), amount, address(this), 0);
    }

    function withdrawFromAave() external {
        uint256 amount = lendingPool.withdraw(
            address(usdc),
            type(uint256).max,
            address(this)
        );
        usdc.approve(address(lendingPool), 0);
    }
}
