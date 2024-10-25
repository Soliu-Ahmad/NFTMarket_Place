// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

contract NFTMarketplace {
    address public marketplaceOwner;
    address public assetBuyer;

    enum SaleStatus {
        NotAvailable,
        Listed,
        InProgress,
        Purchased
    }

    struct Item {
        string itemName;
        uint16 itemPrice;
        SaleStatus saleStatus;
    }

    Item[] public items;
    mapping(uint256 => bool) public hasBeenSold;

    event ItemListed(string indexed itemName, uint16 itemPrice);
    event ItemPurchased(string indexed itemName, uint16 itemPrice, address buyer);

    constructor() {
        marketplaceOwner = msg.sender;
    }

    function addItem(string memory _itemName, uint16 _itemPrice) external {
        require(msg.sender != address(0), "Invalid address");

        Item memory newItem;
        newItem.itemName = _itemName;
        newItem.itemPrice = _itemPrice;
        newItem.saleStatus = SaleStatus.Listed;

        items.push(newItem);

        emit ItemListed(_itemName, _itemPrice);
    }

    function purchaseItem(uint8 _itemIndex) external {
        require(msg.sender != address(0), "Invalid address");
        require(_itemIndex < items.length, "Index out of bounds");
        require(!hasBeenSold[_itemIndex], "Item already sold");

        items[_itemIndex].saleStatus = SaleStatus.Purchased;
        hasBeenSold[_itemIndex] = true;
        assetBuyer = msg.sender;

        emit ItemPurchased(items[_itemIndex].itemName, items[_itemIndex].itemPrice, msg.sender);
    }
}
