// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "contracts/interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract FlashLoanAbuseDetector is ITrap {
    address public constant LOAN_POOL = 0xFba1bc0E3d54D71Ba55da7C03c7f63D4641921B1;

    struct CollectOutput {
        uint256 loanBalance;
    }

    constructor() {}

    function collect() external view override returns (bytes memory) {
        uint256 bal = IERC20(LOAN_POOL).balanceOf(address(this));
        return abi.encode(CollectOutput({loanBalance: bal}));
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        CollectOutput memory current = abi.decode(data[0], (CollectOutput));
        CollectOutput memory past = abi.decode(data[data.length - 1], (CollectOutput));
        if (past.loanBalance == 0) return (false, bytes(""));
        uint256 increase = current.loanBalance - past.loanBalance;
        if (increase > 1e18) return (true, bytes(""));
        return (false, bytes(""));
    }
}
