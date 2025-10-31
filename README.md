# Paste the Markdown content below into the nano editor, then save (Ctrl+X, Y, Enter).

# FlashLoanAbuseDetector (Drosera Proof-of-Concept)

## Overview
This trap monitors for potential flash loan abuse by tracking the loan balance in a specified pool. It is critical as it helps in identifying unusual spikes in loan activity that may indicate malicious intent.

---

## What It Does
* Monitors the loan balance in the specified loan pool.
* Triggers if the loan balance increases by more than 1 ETH from the last recorded balance.
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
// The AI MUST insert the full, syntax-highlighted Solidity code of the `shouldRespond()` logic here.
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
* **Monitoring Target:** Watching the loan balance at the specified loan pool address 0x0000000000000000000000000000000000000000.
* **Deterministic Logic:** Explains the use of the `view` or `pure` modifier. This logic is always executed off-chain by operators to achieve consensus before a transaction is proposed.
* **Calculation/Thresholds:** Uses a fixed 1 ETH increase threshold that drives the `shouldRespond()` function.
* **Response Mechanism:** On trigger, the trap calls the external Responder contract, demonstrating the separation of monitoring and action.
