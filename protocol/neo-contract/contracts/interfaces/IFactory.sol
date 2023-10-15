//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

interface IFactory {
    function createExchange(address _token) external returns (address);

    function getExchange(address _token) external view returns (address);
}
