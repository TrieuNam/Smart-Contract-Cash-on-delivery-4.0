pragma solidity >=0.4.5;
contract DepositShipper {
    address payable private ower;
    
    address payable private buyer;

    address payable private shipper;
     
    modifier onlyShipper{
        require(msg.sender == shipper);
        _;
    }
    constructor() payable public {
        ower = msg.sender;
        
    }
        
    function() external payable { //fallback function
    }
    function getEther() public view returns(uint) {
       return address(this).balance;    
    }
    //return address ower
    function getOwer() public view returns(address payable) {
       return ower;    
    }
  // shipper
    function refundToShipperAndSellerTrue() payable  public {
        address(ower).transfer(getEther());
    }
    //refund full money to ower, and seller if sesssion successs
    function refundToShipperAndSellerFail(address payable _seller) payable  public {
        //send to seller
        address(_seller).transfer(getEther());
    }
}