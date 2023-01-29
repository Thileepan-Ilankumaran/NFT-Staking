// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ThileepToken is ERC20, Ownable {
    constructor(uint256 totalSupply) ERC20("ThileepToken", "TKN") {
        _mint(owner(), totalSupply);
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Mint amount must be greater than zero.");
        _mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount) public onlyOwner {
        require(_amount > 0, "Burn amount must be greater than zero.");
        _burn(_from, _amount);
    }
}
