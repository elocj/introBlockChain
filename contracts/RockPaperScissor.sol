pragma solidity ^0.5.12;

contract RockPaperScissors {
    // Parameters of the game.
    address public owner;
    address payable public dealer;
    address payable public player;

    uint public dealerFund;
    uint public playerFund;

    // Set to true at the end, disallows any change
    bool ended; 
    // Events that will be fired on changes.
    event GameState(string winner, uint amount);
    event GameEnded(address winner, uint amount);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);    

    // for MetaCoin
    mapping(address => uint) balances;
    
    function() external payable {}

    // Create a RockPaperScissors game
    // Owner is assigned to perform admin tasks
    constructor() public {
        owner = msg.sender;
    }

    function setDealer(address payable _dealer, uint _fund) payable public returns (bool success) {
        dealer = _dealer;
        balances[dealer] = _fund;
        return true;
    }

    function setPlayer(address payable _player, uint _fund) payable public returns (bool success) {
        player = _player;
        balances[player] = _fund;
        return true;
    }

    // compare actions to determine winner
    // 0: rock, 1: paper, 2: scissor
    function compare(uint dealerAction, uint playerAction, uint bettingAmount) public returns (string memory results) {
        if(dealerAction == playerAction) {
            results = 'Tied, play again.';
            emit GameState(results, bettingAmount);
            return results;
        }

        // determine the winner
        bool isPlayerWinner = false;
        if(dealerAction == 0) {
            if(playerAction == 1) {
                results = 'Player won!';
                isPlayerWinner = true;
            } else if(playerAction == 2) {
                results = 'Dealer won!';
            }
        } else if(dealerAction == 1) {
            if(playerAction == 0) {
                results = 'Dealer won!';
            } else if(playerAction == 2) {
                results = 'Player won!';
                isPlayerWinner = true;
            }
        } else if(dealerAction == 2) {
            if (playerAction == 0) {
                results = 'Player won!';
                isPlayerWinner = true;
            } else if (playerAction == 1) {
                results = 'Dealer won!';
            }            
        }

        emit GameState(results, bettingAmount);

        // send betting amount
        if(isPlayerWinner) {
            if(sendCoin(dealer, player, bettingAmount)) {
                // continue game
            } else {
                // end of game
                ended = true;
                results = 'Dealer got bankrupted!';
                emit GameEnded(player, getBalanceInEth(player));
            } 
        } else {
            if (sendCoin(player, dealer, bettingAmount)) {
                // continue game
            } else {
                // end of game
                ended = true;
                results = 'Player got bankrupted!';
                emit GameEnded(dealer, getBalanceInEth(dealer)); 
            }
        }
        return results; 
    }

    function sendCoin(address sender, address receiver, uint amount) public returns(bool sufficient) { 
        if (balances[sender] < amount) return false;
        balances[sender] -= amount;
        balances[receiver] += amount;
        emit Transfer(sender, receiver, amount);
        return true; 
    }

    function getBalanceInEth(address addr) public view returns(uint){
        return convert(getBalance(addr), 1);
    }

    function convert(uint amount,uint conversionRate) public pure returns (uint convertedAmount) {
        return amount * conversionRate;
    }

    function getBalance(address addr) public view returns(uint) {
        return balances[addr];
    }
}
