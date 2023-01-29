// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ThileepNFT is ERC1155, Ownable {
    uint256 public constant TNFT = 1000;

    constructor(string memory uri) onlyOwner ERC1155(uri) {
        _mint(msg.sender, TNFT, 100000, "");
    }

    function burnNFT(uint256 _id, uint256 _amount) external {
        require(_amount != 0, "Burn amount cannot be zero.");
        require(balanceOf(msg.sender, _id) >= _amount, "Insufficient balance.");
        _burn(msg.sender, _id, _amount);
    }

    function mintNFT(address _to, uint256 _id, uint256 _amount) external {
        require(_amount != 0, "Mint amount cannot be zero.");
        _mint(_to, _id, _amount, "");
    }
}
