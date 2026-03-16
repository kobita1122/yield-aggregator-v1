# Yield Aggregator V1

A professional, expert-level yield optimization vault designed for decentralized finance (DeFi). This repository features a flat-file architecture for a yield aggregator that maximizes user returns by interacting with multiple external lending protocols.

### Features
* **Vault Tokenization**: Users receive "yTokens" representing their share of the pool, which appreciate in value as yield is earned.
* **Strategy Pattern**: Modular design to switch between different lending platforms (e.g., Aave, Compound).
* **Automated Rebalancing**: Logic to shift capital to the highest-yielding protocol.
* **Safety Buffer**: Maintains a reserve to ensure liquidity for small withdrawals without triggering full capital shifts.

### How to Use
1. Deploy `YieldVault.sol` with the address of the underlying asset (e.g., USDC or DAI).
2. Users call `deposit` to supply capital and receive minted vault shares.
3. The owner or a bot calls `rebalance` to move funds to the strategy with the best APY.
4. Users call `withdraw` to burn shares and receive their principal plus earned yield.
