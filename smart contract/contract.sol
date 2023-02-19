// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract HaulSwap {
    address payable public owner;
    uint256 public totalPayment;
    mapping(address => uint256) public driverPayments;
    mapping(address => bool) public driversPaid;
    uint256 public nodePayoff;
    bool reachedLocation;
    uint256 public timeLimit;
    uint256 public startTime;
 
    constructor() {
        owner = payable(msg.sender);
        totalPayment = 0;
        reachedLocation = true;
        nodePayoff = 0;
        timeLimit = 0;
    }
 
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }
 
    function setNodePayoff(uint256 _nodePayoff) public onlyOwner {
        nodePayoff = _nodePayoff;
    }
 
    function addPayment(address driver) public payable {
        require(reachedLocation == true, "Driver should reach location to be paid");
        driverPayments[driver] += msg.value;
        totalPayment += msg.value;
        nodePayoff = 0;
        reachedLocation = false;
    }
 
    function getDriverPayment(address driver) public view returns (uint256) {
        return driverPayments[driver];
    }
 
    function payDriver(address driver) public payable onlyOwner {
        // require(driverPayments[driver] > 0, "Driver has no payment to withdraw.");
 
        driversPaid[driver] = true;
        payable(driver).transfer(driverPayments[driver]);
    }
 
    function setStatus(bool reached) public {
        reachedLocation = reached;

    }
 
    function newPayoff(uint nodeNew) public {
        nodePayoff = nodeNew;
    }
 
    function setTimeLimit(uint256 _timeLimit) public onlyOwner {
        timeLimit = _timeLimit;
    }
 
    function setStartTime(uint256 _startTime) public onlyOwner {
        startTime = _startTime;
    }
 
    function withdraw() public onlyOwner {
        require(reachedLocation == false, "Driver has already reached the location.");
        require(block.timestamp >= startTime + timeLimit, "Time limit has not been reached yet.");
        owner.transfer(address(this).balance);
    }
}