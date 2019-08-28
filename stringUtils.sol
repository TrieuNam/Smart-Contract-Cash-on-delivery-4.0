pragma solidity >=0.4.5;
import './DepositSeller.sol';
import './DepositBuyer.sol';
import './DepositShipper.sol';
import './stringUtils.sol';


contract Seller {
    address  private seller;
    // address  public buyer;
    uint public id = 0;

    struct Package {
        string name;
        uint price;
        string details;
        string address_delivery;
    }

    mapping(uint => Package) packages;
    
    mapping(uint => bool) flag_buyer;
    mapping(uint => bool) flag_shipper;
    
    mapping(uint => address payable) mapping_buyer;
    mapping(uint => address payable) mapping_seller_deposit;
    
    mapping(uint => address payable) mapping_buyer_deposit;
    
    mapping(uint => address payable) mapping_shipper_deposit;
 
    modifier  onlySeller{
        require(msg.sender == seller);
        _;
    }
    
    constructor()  public payable {
        seller = msg.sender;    
    }  

   function setPackage(string memory _name, uint  _price,string memory _details) onlySeller public{//1
        
        packages[id].name = _name;
        packages[id].price = _price;
        packages[id].details = _details;
        id++;
       
   }
   

    //get address seller_deposit_to
    function setSellerDepositAddress(uint _id, address payable _address) public{
        mapping_seller_deposit[_id] = _address;
    }
    //get address seller_deposit_to
    function setShipperDepositAddress(uint _id, address payable _address) public{
        mapping_shipper_deposit[_id] = _address;
    } 
   // mua hang
    function buyItem(uint _id,string memory _address, 
    address payable _address_buyer_deposit) //, uint _out0, uint _out1,address _address_verifyTx,
    public returns(string memory _name, uint  _price,string memory _details, string memory _address_real){
        //require Package available
        require(packages[_id].price > 0,"Package unavailable");
        //make sure no one buy it before
        require(mapping_buyer[_id] == 0x0000000000000000000000000000000000000000,"Package bought");
       // dia chi mua
        mapping_buyer[_id] = msg.sender;
       // buyer = msg.sender;
        // dia chi giao
        packages[_id].address_delivery = _address;
      //address buyer deposit
        mapping_buyer_deposit[_id] = _address_buyer_deposit;
   
        return(
            packages[_id].name,
            packages[_id].price,
            packages[_id].details,
            _address);
    }
    
     //run address seller_deposit_to
    function runRefundTrue(uint _id)   public  payable {
        address payable seller_deposit_temp = mapping_seller_deposit[_id];
        address payable buyer_deposit_temp =  mapping_buyer_deposit[_id];
        address payable shipper_deposit_temp =  mapping_shipper_deposit[_id];
        DepositShipper(shipper_deposit_temp).refundToShipperAndSellerTrue();
        //refund seller pay shiper
        address payable shipper_temp =  DepositShipper(shipper_deposit_temp).getOwer();
        DepositSeller(seller_deposit_temp).refundToSellerTrue(shipper_temp);
        //refund buyer pay seller
         address payable seller_temp = DepositSeller(seller_deposit_temp).getOwer();
         DepositBuyer(buyer_deposit_temp).refundToBuyerTrue(seller_temp);
        //refund shiper 
        
    }
    
    //run address seller_deposit_to
    function runRefundFail(uint _id) public onlySeller    payable{
        address payable seller_deposit_temp = mapping_seller_deposit[_id];
        address payable buyer_deposit_temp =  mapping_buyer_deposit[_id];
        address payable shipper_deposit_temp =  mapping_shipper_deposit[_id];
        //refund seller
        DepositSeller(seller_deposit_temp).refundToSellerFail();
        //refund buyer
        DepositBuyer(buyer_deposit_temp).refundToBuyerFail();
        //refund buyer and seller
        address payable seller_temp = DepositSeller(seller_deposit_temp).getOwer();
        DepositShipper(shipper_deposit_temp).refundToShipperAndSellerFail(seller_temp);
    }
    
      
      // seller fail
      function reunfundSellerFail(uint _id) payable  public {
        address payable seller_deposit_temp = mapping_seller_deposit[_id];
        address payable buyer_deposit_temp =  mapping_buyer_deposit[_id];
        DepositSeller(seller_deposit_temp).refundToSellerFail();
        DepositBuyer(buyer_deposit_temp).refundToBuyerFail();
        
       
      }
      
      function setFagSellerFail(uint _id, string memory _name) public {
          string memory name ;
          packages[_id].name  = name;
          if(StringUtils.equal(name,_name) == false){
              reunfundSellerFail(_id);
          }
      }
      
      
     function runFundFailShiper(uint _id) payable public {
        address payable seller_deposit_temp = mapping_seller_deposit[_id];
        address payable buyer_deposit_temp =  mapping_buyer_deposit[_id];
        address payable shipper_deposit_temp =  mapping_shipper_deposit[_id];
        address payable seller_temp = DepositSeller(seller_deposit_temp).getOwer();
        DepositShipper(shipper_deposit_temp).refundToShipperAndSellerFail(seller_temp);
        DepositSeller(seller_deposit_temp).refundToSellerFail();
        DepositBuyer(buyer_deposit_temp).refundToBuyerFail();
        
     } 
      
      //setFlagShipperFail
      function setFlagShipperFail(uint _id) public{
            runFundFailShiper(_id);
    }
    
    function runFundFailBuyer(uint _id) payable public {
        address payable seller_deposit_temp = mapping_seller_deposit[_id];
        address payable buyer_deposit_temp =  mapping_buyer_deposit[_id];
        address payable shipper_deposit_temp =  mapping_shipper_deposit[_id];
         DepositShipper(shipper_deposit_temp).refundToShipperAndSellerTrue();
         address payable seller_temp = DepositSeller(seller_deposit_temp).getOwer();
         DepositBuyer(buyer_deposit_temp).refundToBuyerTrue(seller_temp);
         address payable shipper_temp =  DepositShipper(shipper_deposit_temp).getOwer();
        DepositSeller(seller_deposit_temp).refundToSellerTrue(shipper_temp);
    } 
    
      
   //================= buyer fail
// set flag buyer fail
    function setFlagBuyerFail(uint _id) payable public{
            runRefundTrue(_id);
    }
    
    //set flag buyer
    function setFlagBuyerAndShiper(uint _id) payable public{
       
            runRefundTrue(_id);
         
    }
    
     
    
}

