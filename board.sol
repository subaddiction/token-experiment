pragma solidity ^0.4.16;

contract Board {
    // Dapp name
    string public name = "Messages";
    
    // Trigger an event returning the message
    event Message(address indexed from, string message);
    
    function sendMessage(string message)
    public
    returns (string)
    {
        Message(msg.sender, message);
        return (message);
    }
}