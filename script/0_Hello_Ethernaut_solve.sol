// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/0_Hello_Ethernaut.sol";

contract POC is Script {
    Instance public target;

    // function setUp() external {
    //     target = new Instance();
    // }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Instance(0x3E63de5Bfa3fE54dC8C6523b24a7888961754386);
        bool res = target.getCleared();
        console.log("before: ", res);

        string memory password = target.password();
        target.authenticate(password);

        res = target.getCleared();
        console.log("after: ", res);
        vm.stopBroadcast();
    }
}