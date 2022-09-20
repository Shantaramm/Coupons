// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Coupons{

    IERC20 token;
    address owner;
    mapping(bytes32 => address) private ownerCoupon;
    mapping(bytes32 => uint256) private contentCoupon;
    mapping(address => bytes32) private myCoupons;
    mapping(bytes32 => address) private createrCoupons;



    constructor(address _token) {
        token = IERC20(_token);
        owner = msg.sender;
    }

    function newCoupon(uint256 _amount, address futureUser, string memory _nonce) external {
        bytes32 coupon = keccak256(abi.encodePacked(_amount, futureUser, _nonce, msg.sender));
        require(contentCoupon[coupon] == 0, "Come up with another secret word");
        require(token.balanceOf(msg.sender) >= _amount , "You don't have enough tokens!!!");
        token.transferFrom(msg.sender, address(this), _amount);
        ownerCoupon[coupon] = futureUser;
        contentCoupon[coupon] = _amount;
        myCoupons[msg.sender] = coupon;
    }

    function useCoupon(bytes32 _coupon) external{
        require(ownerCoupon[_coupon] == msg.sender, "You are not a coupon user");
        uint256 amountTokens = contentCoupon[_coupon];
        address creater = createrCoupons[_coupon];
        delete ownerCoupon[_coupon];
        delete contentCoupon[_coupon];
        delete myCoupons[creater];
        delete createrCoupons[_coupon];
        token.transfer(msg.sender, amountTokens);
    }

    function ShowMyCoupons() external view  returns (bytes32){
        require(myCoupons[msg.sender] != bytes32(0), "You don't have coupons");
        return myCoupons[msg.sender];
    }

}
