pragma solidity ^0.8.13;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/IERC20.sol";

// import "ds-token/token.sol";
// interface ERC20 {
//     function balanceOf(address owner) external view returns (unit);
//     function allowance(address owner, address spender) external view returns (unit);
//     function approve(address spender, uint value) external returns (bool);
//     function transfer(address to, uint value) external returns (bool);
//     function transferFrom(address from, address to, uint value) external returns (bool); 
//     }

contract Emarketwithcoin {
	struct Item {
	    string description;
	    address seller;
	    address buyer;
	    uint price;
        uint quantity;
	    bool sold;
	}

	mapping(uint256=>Item) public items;
	uint256 public itemCount;

	function addItem(string memory _description, uint _price, uint _quantity) public returns(uint) {
	    itemCount++;
	    items[itemCount].description = _description;
	    items[itemCount].seller = msg.sender;
	    items[itemCount].price = _price;
	    items[itemCount].quantity = _quantity;
	    return itemCount;
	}

	function getItem(uint _index) public view returns(string memory, uint, uint){
	    Item storage i = items[_index];
	    require(i.seller != address(0), "no such item"); // not exists
	    return(i.description, i.price, i.quantity);
	}

	function checkItemExisting(uint _index) public view returns (bool) {
	    Item storage i = items[_index];
	    return (i.seller != address(0));
	}

	function checkItemSold(uint _index) public view returns (bool) {
	    Item storage i = items[_index];
	    require(i.seller != address(0), "no such item"); // not exists
	    return i.sold;
	}

	function removeItem(uint _index) public {
	    Item storage i = items[_index];
	    require(i.seller != address(0), "no such item"); // not exists
	    require(i.seller == msg.sender, "only seller can remove item");
	    require(!i.sold, "item sold already");
	    delete items[_index];
	}

	function buyItem(uint _index) public {
	    Item storage i = items[_index];
		// IERC20 tokenContract =  IERC20(0xf672aF317f2D05794DB6DB0001E771d24cF340c9);
		IERC20 tokenContract =  IERC20(0xd9145CCE52D386f254917e481eB44e9943F39138);
	    require(i.seller != address(0), "no such item"); // not exists
	    require(!i.sold, "item sold already");
	    require(i.price <= tokenContract.balanceOf(msg.sender), "not enough tokens");
	    i.buyer = msg.sender;
        i.quantity = i.quantity - 1;
        if (i.quantity < 1) {
            i.sold = true;
        }
		tokenContract.approve(msg.sender, i.price);
	    tokenContract.transfer(i.seller, i.price);
	}

}
