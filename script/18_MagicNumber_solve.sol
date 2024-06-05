// SDPX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/18_MagicNumber.sol";

contract POC is Script {
    MagicNum public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = MagicNum(0xb98D5A28a215101eA5472dD7F6F2bE64093f52C9);
        bytes memory code = "\x60\x0a\x60\x0c\x60\x00\x39\x60\x0a\x60\x00\xf3\x60\x2a\x60\x80\x52\x60\x20\x60\x80\xf3";
        address solver;

        assembly {
            solver := create(0, add(code, 0x20), mload(code))
        }

        target.setSolver(address(solver));

        vm.stopBroadcast();
    }
}