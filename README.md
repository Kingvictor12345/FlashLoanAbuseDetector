# FlashLoanAbuseDetector (Drosera Proof-of-Concept)

## Overview
This trap monitors for potential flash loan abuse by tracking the loan balance of a specified pool. It triggers alerts when significant increases in loan balances are detected, which may indicate abuse.

---

## What It Does
* Monitors the loan balance of the specified loan pool.
* Triggers if the loan balance increases by more than 1 ETH from the previous check.
* It demonstrates the essential Drosera trap pattern using deterministic logic.

---

## Key Files
* `src/FlashLoanAbuseDetector.sol` - The core trap contract containing the monitoring logic.
* `src/SimpleResponder.sol` - The required external response contract.
* `drosera.toml` - The deployment and configuration file.

---

## Detection Logic

The trap's core monitoring logic is contained in the deterministic `shouldRespond()` function.

solidity
function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
    CollectOutput memory current = abi.decode(data[0], (CollectOutput));
    CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
    if (past.loanBalance == 0) return (false, bytes(""));
    uint256 increase = current.loanBalance - past.loanBalance;
    if (increase > 1e18) return (true, bytes(""));
    return (false, bytes(""));
}


---

## 🧪 Implementation Details and Key Concepts
* **Monitoring Target:** Watching the loan balance of the pool at address 0xFba1bc0E3d54D71Ba55da7C03c7f63D4641921B1.
* **Deterministic Logic:** This logic is always executed off-chain by operators to achieve consensus before a transaction is proposed.
* **Calculation/Thresholds:** Uses a fixed threshold of 1 ETH increase to trigger a response.
* **Response Mechanism:** On trigger, the trap calls the external Responder contract, demonstrating the separation of monitoring and action.

---

## Test It
To verify the trap logic using Foundry, run the following command (assuming a test file has been created):

bash
forge test --match-contract FlashLoanAbuseDetector
