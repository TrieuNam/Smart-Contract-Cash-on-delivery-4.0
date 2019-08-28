pragma solidity >=0.4.5;
import './DepositShipper.sol';

contract DepositSeller {
    address payable private seller;
    address payable  private ower;
    address payable private shipper;
    
     modifier onlySeller{
        require(msg.sender == seller);
        _;
    }
    
    
    //_address is address real in the world, ship will tranfer packeage to
    constructor() payable public {
        ower = msg.sender;    
    }
    function() external payable { //fallback function
        
    }
    
    function getEther() public view returns(uint) {
       return address(this).balance;    
    }

    function getOwer() public view returns(address payable) {
       return ower;    
    }

    //refund full money to ower
    function refundToSellerTrue(address payable _shiper) payable  public {
        address(_shiper).transfer(getEther());
    }
    //refund full money to ower Fail
    function refundToSellerFail() payable  public {
        address(ower).transfer(getEther());
    }
}