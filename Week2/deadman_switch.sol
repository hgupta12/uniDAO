// SPDX-License-Identifier: MIT
/**
 * @dev Function to withdraw funds.
 * @custom:dev-run-script "transferFunds"
 */
pragma solidity ^0.8.3;

contract DeadManSwitch{
    address public owner;
    address payable public targetAddress;
    uint public deadline;
    uint private duration;
    uint public balance;

    constructor(uint _duration, address payable _addr) payable {
        owner = msg.sender;
        duration = _duration;
        deadline = block.timestamp + _duration;
        targetAddress = _addr;
        balance = msg.value;

    }

    modifier onlyOwner{
        require(msg.sender == owner, "Only owner is allowed to perform this action!");
        _;
    }

    modifier deadlinePassed{
        require(block.timestamp >= deadline, "The deadline has not passed yet!");
        _;
    }

    modifier validTarget(address _target){
        require(_target != address(0), "Invalid recipent address!");
        _;
    }

    function changeOwner(address payable newOwner) public onlyOwner {
        owner = newOwner;
    }

    function changeTarget(address payable newTarget) public onlyOwner validTarget(newTarget){
        targetAddress = newTarget;
    }

    function transferFunds() public payable deadlinePassed {
        targetAddress.transfer(address(this).balance);
    }

    function checkIn() public onlyOwner{
        deadline = block.timestamp + duration;
    }
}