// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Coupons{

    mapping(bytes32 => uint256) private coupons;
    mapping(address => bytes32) private myCoupons;
    IERC20 token;
    address owner;
     
     constructor(address _token){
         token = IERC20(_token);
         owner = msg.sender;
     }

    function CreateCoupons(uint256 _amount, uint256 _nonce) external {
        require(token.balanceOf(msg.sender) >= _amount , "You don't have enough tokens!!!");
        token.transferFrom(msg.sender, address(this), _amount);
        bytes32 coupon = keccak256(abi.encodePacked(_amount, _nonce, msg.sender));
        coupons[coupon] = _amount;
        myCoupons[msg.sender] = coupon;
        
     }

    function SpendCoupon(bytes32 coupon) external {
        require(token.balanceOf(address(this)) > 0, "No coupons created");
        require(token.balanceOf(address(this)) > 0, "No coupons created");
        require(coupons[coupon] > 0, "Coupon spent or didn't exist at all!");
        uint256 tokens = coupons[coupon];
        delete coupons[coupon];
        token.transfer(msg.sender, tokens);
    }

    function ShowMyCoupons() external view  returns (bytes32){
        require(myCoupons[msg.sender] != bytes32(0), "You don't have coupons");
        return myCoupons[msg.sender];
    }

}

