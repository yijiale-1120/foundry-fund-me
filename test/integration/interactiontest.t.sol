// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fund_me.sol";
import {FundFundMe, WithDrawFundMe} from "../../script/interactions.s.sol";
import {DeployFundMe} from "../../script/deploy_fund_me.s.sol";

contract InteractionTest is Test {
    FundMe fundMe;
    address alice;

    address USER = makeAddr("USER");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
        alice = makeAddr("Alice");
        vm.deal(alice, STARTING_BALANCE);
    }

    function testUserCanFundMeInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();

        fundFundMe.fundFundMe(address(fundMe));

        WithDrawFundMe withDrawFundMe = new WithDrawFundMe();

        withDrawFundMe.withdrawFundMe(address(fundMe));
        assert(address(fundMe).balance == 0);
    }

    function testUSERaddress() public view returns (address) {
        return USER;
    }

    function testAliceAddress() public view returns (address) {
        return alice;
    }

    function testUserCanFundMeInteractionsForAlice() public {
        uint256 preUserBalance = alice.balance;
        uint256 preOwnerBalance = address(fundMe.getOwner()).balance;
        // vm.deal(alice, STARTING_BALANCE);只对当前的测试对象有效，集成测试含多个测试对象会覆盖
        vm.prank(alice); // 设置调用者为 Alice
        fundMe.fund{value: SEND_VALUE}();
        // FundFundMe fundFundMe = new FundFundMe();
        // Alice 向 FundMe 合约提供资金
        // fundFundMe.fundFundMe(address(fundMe));[FAIL: vm.startBroadcast: you have an active prank; broadcasting and pranks are not compatible]
        // 遇到冲突时，不必强行使用脚本部署每一个单元，集成测试考虑的主要是单元之间的交互作用
        WithDrawFundMe withDrawFundMe = new WithDrawFundMe();
        // 从 FundMe 合约提取资金
        withDrawFundMe.withdrawFundMe(address(fundMe));
        uint256 afterUserBalance = alice.balance;
        uint256 afterOwnerBalance = address(fundMe.getOwner()).balance;
        // 验证 FundMe 合约的余额为 0
        assert(address(fundMe).balance == 0);
        assertEq(afterUserBalance + SEND_VALUE, preUserBalance);
        assertEq(preOwnerBalance + SEND_VALUE, afterOwnerBalance);

        // 验证 Alice 的余额增加了 SEND_VALUE

        // assertEq(afteralice, prealice + SEND_VALUE);
    }
}
