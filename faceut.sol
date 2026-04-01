pragma solidity ^0.5.16;


contract owned {
    address owner;
    constructor () public {
        owner = msg.sender;
    }
    // Access control modifier
    modifier onlyOwner {
        require(msg.sender == owner, 
            "Only the contract owner can call this function");
        _;
    }
}
contract mortal is owned {
    // Contract destructor
    function destroy() public onlyOwner(){
        selfdestruct(msg.sender);
    }
}
// Faucet
contract Faucet is mortal {
    // Create event object to log on-chain msg??
    event Withdraw(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);
    // Main function -> Give out ether to anyone who asks
	function withdraw(uint withdraw_amount) public {
        // Limit withdrawl amount
        require(withdraw_amount <= 0.1 ether);
        require(address(this).balance >= withdraw_amount, 
            "Insufficient ether in faucet to withdrawl request");
        // Send the ether to the address that requested
        msg.sender.transfer(withdraw_amount);
        // Emit incorporate the event data in the transaction logs
        emit Withdraw(msg.sender, withdraw_amount);
    }
    // receive external payment
    function () external payable {
        // emit the log of the deposit
        emit Deposit(msg.sender, msg.value);
    }
}
