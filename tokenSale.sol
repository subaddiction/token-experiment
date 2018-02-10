pragma solidity ^0.4.16;

interface token {
    function transfer(address receiver, uint amount) public;
    function balanceOf(address ethWallet) view returns (uint);
}

contract TokenSale {
    address public beneficiary;
    uint public amountRaised;
    uint public priceInWei;
    uint public tokensAvailable;
    token public tokenReward;
    
    event UpdatedTokensAvailable(uint amount);
    event WithdrawalExecution(uint amount);

    /**
     * Constructor function
     *
     * Setup the owner
     */
    function TokenSale(
        address addressOfTokenUsedAsReward,
        uint costOfEachToken,
        uint initialOffer
    ) {
        tokenReward = token(addressOfTokenUsedAsReward);
        beneficiary = msg.sender;
        priceInWei = costOfEachToken * 1 finney; // price '1' = 1 finney = 0.001 ETH
    }

    /**
     * Funding function
     *
     * The function without name is the default function that is called whenever anyone sends funds to a contract
     */
    function () payable {
        
        //IF someone is sending ETH
        if(msg.sender != beneficiary){
            uint amount = msg.value;
            require(amount > 0);
            uint tokensToPay = amount * 1 ether / priceInWei;
            //if contract owns enough tokens...
            require(tokenReward.balanceOf(address(this)) > tokensToPay);
            //...pay the order
            tokenReward.transfer(msg.sender, tokensToPay);
            tokensAvailable -= tokensToPay;
            //Update total ETH raised with this contract
            amountRaised += amount;
        }
        
        uint available = tokenReward.balanceOf(address(this));
        
        if(available != tokensAvailable){
            tokensAvailable = available;
            UpdatedTokensAvailable(available);
        }
        
        
        
    }
    
    modifier onlyOwner {
        require(msg.sender == beneficiary);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        beneficiary = newOwner;
    }
    
    function withdraw() onlyOwner public {
            uint balance = this.balance;
            beneficiary.transfer(balance);
            WithdrawalExecution(balance);
    }
    
    function retireSale() onlyOwner public {
        uint available = tokenReward.balanceOf(address(this));
        if(available > 0){
            tokenReward.transfer(msg.sender, available);
            tokensAvailable = 0;
            UpdatedTokensAvailable(0);
        }
        
    }
}