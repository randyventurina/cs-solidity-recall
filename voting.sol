pragma solidity ^0.4.22;

contract Voting {
    address comelec;
    
    constructor() public {
        comelec = msg.sender;
    }
    
    struct Voter{
        uint vote;
        address delegate;
        uint weight;
        bool voted;
    }
    
    struct Candidate{ 
        bytes16 name;
        uint votes;
    }
    
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    
    uint winner; 
    
    function addVoter(address voter) public {
        require(voter != comelec, "Comelec not allowed to be registered");
        
        require(!voters[voter].voted, "Already voted");
        
        voters[voter].weight = 1;
    }
    
    function vote(uint candidateId) public { 
        
        Voter storage voter = voters[msg.sender];
        
        require(msg.sender != comelec, "Commelec not allowed to vote");
        
        require(!voter.voted, "Voter has already voted");
        
        voter.voted = true;
        voter.vote = candidateId;
        
        candidates[candidateId].votes += voter.weight;
    }
    
    function addCandidates(bytes16[] names) public {
        for(uint i = 0; i < names.length; i++){ 
            candidates.push(Candidate({
                name: names[i],
                votes: 0
            }));
        }
    }
    
    function getWinner() public view {
        
        Candidate storage leading = candidates[0];
        
        for(uint i = 1; i < candidates.length; i ++){
            
            if(candidates[i].votes > leading.votes){
                leading = candidates[i];
            }
        }
    }
}