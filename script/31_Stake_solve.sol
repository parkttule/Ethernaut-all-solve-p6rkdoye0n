// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/31_Stake.sol";

contract POC is Script {
    Stake public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Stake(0x4c7A44ef634d5FbA3B93982651B710300ffa6BCD);
        console.log(address(target));
        // address WETH = target.WETH();
        // console.log("WETH: ", WETH);
        target.StakeETH{value : 0.0011 ether}();
        // address(target).call{value : 0.0011 ether}(abi.encodeWithSignature("StakeETH()"));
        vm.stopBroadcast();
    }
}