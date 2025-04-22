// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fund_me.sol";

contract FundFundMe is Script {
    uint constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // 0x5c69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
        // 0x5c69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f

        fundFundMe(mostRecentlyDeployed);
    }
}

contract WithDrawFundMe is Script {
    uint constant SEND_VALUE = 0.1 ether;

    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        // 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // 0x5c69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
        // 0x5c69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f

        withdrawFundMe(mostRecentlyDeployed);
    }
}
