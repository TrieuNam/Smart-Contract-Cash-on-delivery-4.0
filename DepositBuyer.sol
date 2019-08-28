pragma solidity >=0.5.1;
import './DepositSeller.sol';
contract DepositBuyer {
    address payable private ower;
     address payable private buyer;
     
    constructor() payable public {
        ower = msg.sender;    
    }
     modifier onlyBuyer{
        require(msg.sender == buyer);
        _;
    }
    function() external payable { //fallback function
        
    }
    
    function getEther() public view returns(uint) {
       return address(this).balance;    
    }
    function getOwer() public view returns(address payable) {
       return ower;    
    }
    function getEtherOwer() public view returns(uint){
       return ower.balance;
    }

    //refund full money to ower
    function refundToBuyerTrue(address payable _seller) public   payable {
        address(_seller).transfer(getEther());
    }
    //refund full money to ower
    function refundToBuyerFail()  public   payable {
        address(ower).transfer(getEther());
    }
}