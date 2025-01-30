// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EasyAuctionMock {
    address private _token;

    constructor(address token) {
        _token = token;
    }

    function transferSomething(address to, uint256 amount) public {
        ERC20(_token).transfer(to, amount);
    }
}