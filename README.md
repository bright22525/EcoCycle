# EcoCycle Smart Contract

EcoCycle is a Clarity smart contract for the Stacks blockchain that incentivizes recycling by rewarding users with fungible tokens (`eco-token`) based on the amount of material they recycle. The contract tracks each user's total recycled weight and allows an admin to adjust the reward rate.

## Features

- **Fungible Token:** Issues `eco-token` as a reward for recycling actions.
- **User Tracking:** Maintains a record of each user's total recycled weight.
- **Configurable Rewards:** Admin can update the reward multiplier (tokens per kg).
- **Transparency:** Users can view their total recycled weight and token balance.

## Functions

### Public Functions

- `log-eco-action (material, weight)`
  - Logs a recycling action for the sender.
  - Mints reward tokens based on the weight and current reward rate.
  - Updates the user's total recycled weight.

- `set-reward-rate (new-rate)`
  - Allows the admin to update the reward multiplier.

### Read-Only Functions

- `get-total-recycled (user)`
  - Returns the total weight recycled by the specified user.

- `get-token-balance (user)`
  - Returns the `eco-token` balance of the specified user.

## Usage

1. **Log a Recycling Action**
   ```clarity
   (contract-call? .EcoCycle log-eco-action "plastic" u5)
