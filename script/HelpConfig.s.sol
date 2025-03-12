// SPDX-LICENSE-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelpConfig is Script {
    NetWorkConfig public activeNewtorkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 20000e8;

    struct NetWorkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNewtorkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNewtorkConfig = getMainnetEthConfig();
        } else {
            activeNewtorkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetWorkConfig memory) {
        // price feed address
        NetWorkConfig memory sepoliaConfig = NetWorkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetWorkConfig memory) {
        // price feed address
        NetWorkConfig memory mainnetEthConfig = NetWorkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainnetEthConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetWorkConfig memory) {
        if (activeNewtorkConfig.priceFeed != address(0)) {
            return activeNewtorkConfig;
        }
        // price feed address

        // Deploy the mocks
        // Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockAggregator = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetWorkConfig memory anvilConfig = NetWorkConfig({
            priceFeed: address(mockAggregator)
        });

        return anvilConfig;
    }
}
