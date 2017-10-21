/*
This Token Contract implements the Peculium token (beta)
.*/


import "./StandardToken.sol";
import "./Ownable.sol";

pragma solidity ^0.4.8;


contract Peculium is StandardToken, Ownable {

	using SafeMath for uint256;
    	/* Public variables of the token */
	string public name = "Peculium"; //token name 
    	string public symbol = "PCL";
    	uint256 public decimals = 8;
    	
    	/* variables for the Peculium PreICO and ICO */
	//uint256 public NB_TOKEN = 20000000000; // number of token to create
        uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; //NB_TOKEN*10** decimals;
	
	
	
	uint256 public constant START_PRE_ICO_TIMESTAMP   =1509494400; //start date of PRE_ICO 
        uint256 public constant START_ICO_TIMESTAMP=START_PRE_ICO_TIMESTAMP+ 10* 1 days ;
	uint256 public constant END_ICO_TIMESTAMP   =1514764800; //end date of ICO 
	
	uint256 public constant THREE_HOURS_TIMESTAMP=10800;// month in minutes  (1month =43200min) 
	uint256 public constant WEEK_TIMESTAMP=604800;
	
	uint256 public constant BONUS_FIRST_THREE_HOURS_PRE_ICO = 35 ; // 35%
	uint256 public constant BONUS_FIRST_TEN_DAYS_PRE_ICO = 30 ; // 35% 
	uint256 public constant BONUS_FIRST_TWO_WEEKS_ICO  = 20 ;
	uint256 public constant BONUS_AFTER_TWO_WEEKS_ICO  = 15 ; 
	uint256 public constant BONUS_AFTER_FIVE_WEEKS_ICO = 10 ;
	uint256 public constant BONUS_AFTER_SEVEN_WEEKS_ICO = 5 ; 
	uint256 public constant INITIAL_PERCENT_ICO_TOKEN_TO_ASSIGN = 25 ; 
	

	uint256 rate;
	
	uint256 public Airdropsamount;
	//Boolean to allow or not the initial assignement of token (batch) 
	bool public batchAssignStopped = false;	
	uint256 amount;
	uint256 tokenAvailableForIco;
	//TeamAndBounty TeamAndBounty;
	
	//Constructor
	function Peculium() {
		//owner = msg.sender;
		//TeamAndBounty TeamAndBounty = new TeamAndBounty(amount);
		rate = 3000; // 1 ether = 3000 Peculium
		amount = MAX_SUPPLY_NBTOKEN;
		balances[owner] = amount;
		tokenAvailableForIco = (amount * INITIAL_PERCENT_ICO_TOKEN_TO_ASSIGN)/ 100;
		Airdropsamount = 50000000*10**8;
		//tokenAvailableAfterIco=amount-(tokenAvailableForIco+TeamAndBounty.teamShare+TeamAndBounty.bountyShare);
                //balances[owner]  = tokenAvailableForIco;
	}
	
	  // fallback function can be used to buy tokens
	function () payable {
	    buyTokens(msg.sender,msg.value);
	  }
	function buyTokens(address beneficiary, uint256 weiAmount) public payable AssignNotStopped NotEmpty
	{
		require (START_PRE_ICO_TIMESTAMP <=now);
		require (msg.value > 0.1 ether);
		address toAddress = beneficiary;
                uint256 amountEther = weiAmount.div(1 ether);
                
		if(now <= (START_PRE_ICO_TIMESTAMP + 10* 1 days))
		{
			buyTokenPreIco(toAddress,amountEther); 
		}

		if(START_ICO_TIMESTAMP <=now && now <= (START_ICO_TIMESTAMP + 8*WEEK_TIMESTAMP))
		{
			buyTokenIco(toAddress,amountEther);
		}
		if(now>(START_ICO_TIMESTAMP + 8*WEEK_TIMESTAMP))
		{
			buyTokenPostIco(toAddress,amountEther);
		}
	
	}
	
	function sendTokenUpdate(address toAddress, uint256 amountTo_Send)
	{
	                    balances[owner].sub(amountTo_Send);
                     	    amount.sub(amountTo_Send);
                            balances[toAddress].add(amountTo_Send);
	
	}

	function buyTokenPreIco(address toAddress, uint256 _vamounts) payable AssignNotStopped NotEmpty ICO_Fund_NotEmpty{
	    require(START_PRE_ICO_TIMESTAMP <=now);
	    require(now <= (START_PRE_ICO_TIMESTAMP + 10* 1 days));
	    if (START_PRE_ICO_TIMESTAMP <=now && now <= (START_PRE_ICO_TIMESTAMP + THREE_HOURS_TIMESTAMP)){   
                 

                     // 1 ether = 3000 Peculium
                     
                     uint256 amountTo_Send = _vamounts*rate*10**decimals *(1+(BONUS_FIRST_THREE_HOURS_PRE_ICO/100));
                     	tokenAvailableForIco.sub(amountTo_Send);	
			sendTokenUpdate(toAddress,amountTo_Send);
                    
            }
	    if (START_PRE_ICO_TIMESTAMP+ THREE_HOURS_TIMESTAMP <=now && now <= (START_PRE_ICO_TIMESTAMP + 10* 1 days)){   
                 
                     
                      amountTo_Send = _vamounts*rate*10**decimals *(1+(BONUS_FIRST_TEN_DAYS_PRE_ICO/100));
                     	tokenAvailableForIco.sub(amountTo_Send);	
			sendTokenUpdate(toAddress,amountTo_Send);
                    
            }
	}

	
	function buyTokenIco(address toAddress, uint256 _vamounts) payable onlyOwner AssignNotStopped NotEmpty ICO_Fund_NotEmpty{
		 require(START_ICO_TIMESTAMP <=now);
	    	 //require (now <= (START_ICO_TIMESTAMP + 7*WEEK_TIMESTAMP));

		 if ((START_ICO_TIMESTAMP) < now && now <= (START_ICO_TIMESTAMP + 2*WEEK_TIMESTAMP) ){
                 
                     
			uint256 amountTo_Send = _vamounts*rate* 10**decimals *(1+(BONUS_FIRST_TWO_WEEKS_ICO/100));
                     
                     	tokenAvailableForIco.sub(amountTo_Send);	
			sendTokenUpdate(toAddress,amountTo_Send);
                    
		}
		if ((START_ICO_TIMESTAMP+ 2*WEEK_TIMESTAMP) < now && now <= (START_ICO_TIMESTAMP + 5*WEEK_TIMESTAMP) ){
		
                     
			amountTo_Send = _vamounts*rate*10**decimals *(1+(BONUS_AFTER_TWO_WEEKS_ICO/100));
                     	tokenAvailableForIco.sub(amountTo_Send);	
			sendTokenUpdate(toAddress,amountTo_Send);
                    
		}
		if ((START_ICO_TIMESTAMP+ 5*WEEK_TIMESTAMP) < now && now <= (START_ICO_TIMESTAMP + 7*WEEK_TIMESTAMP) ){
		
        
			amountTo_Send = _vamounts*rate*10**decimals *(1+(BONUS_AFTER_FIVE_WEEKS_ICO/100));
                     
                     	tokenAvailableForIco.sub(amountTo_Send);	
			sendTokenUpdate(toAddress,amountTo_Send);
                    
		}
		if (START_ICO_TIMESTAMP+ 7*WEEK_TIMESTAMP< now){
		
                     	     amountTo_Send = _vamounts*rate*10**decimals *(1+(BONUS_AFTER_SEVEN_WEEKS_ICO/100));
                     
                     	tokenAvailableForIco.sub(amountTo_Send);	
			sendTokenUpdate(toAddress,amountTo_Send);
                    
		}
	
	}


	function buyTokenPostIco(address toAddress, uint256 _vamounts) payable AssignNotStopped NotEmpty {
		uint256 amountTo_Send = _vamounts*rate*10**decimals;
			sendTokenUpdate(toAddress,amountTo_Send);
	}


	
	function airdropsTokens(address[] _vaddr, uint256[] _vamounts) onlyOwner NotEmpty{
		require ( batchAssignStopped == false );
		require ( _vaddr.length == _vamounts.length );
		//Looping into input arrays to assign target amount to each given address 
		if(now == END_ICO_TIMESTAMP){
			for (uint index=0; index<_vaddr.length; index++) {
			address toAddress = _vaddr[index];
			uint amountTo_Send = _vamounts[index] * 10 ** decimals;
			sendTokenUpdate(toAddress,amountTo_Send);
                    
			}
			
		}
              
	}

	//TeamAndBounty.teamPayment(address teamaddr);
	
	//TeamAndBounty.change_bounty_manager (address public_key);
	
 
	/* Approves and then calls the receiving contract */
	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);

		require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
        	return true;
    }

	
   

  	function getBlockTimestamp() constant returns (uint256){
        	return now;
  	}


	function stopBatchAssign() onlyOwner {
      		require ( batchAssignStopped == false);
      		batchAssignStopped = true;
	}
	function restartBatchAssign() onlyOwner {
      		require ( batchAssignStopped == true);
      		batchAssignStopped = false;
	}

    modifier AssignNotStopped {
        require (!batchAssignStopped);
        _;
    }
        modifier NotEmpty {
        require (amount>0);
        _;
    }
        modifier ICO_Fund_NotEmpty {
        require (tokenAvailableForIco> rate*10**decimals);
        _;
    }
    
  	function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  {
    		ownerAddr = owner;
		ownerBalance = balanceOf(ownerAddr);
  	}


	function killContract() onlyOwner { // function to destruct the contract.
		selfdestruct(owner);
 	}
}