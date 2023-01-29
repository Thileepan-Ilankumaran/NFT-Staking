# NFT-Staking

## Assignment

### To create ERC 1155 Staking Smart Contract

->APR should be 5,10,15% for 1,6,12 months and above respectively.



### Download repository and follow these steps :-

1. Run the command `npm install` to install dependencies. Import openzepplin by `npm install @openzeppelin/contracts`.

2. Then compile `npx hardhat compile` where you should see "Compiled 28 solidity files successfully".

3. Test smart contracts in local hardhat node by `npm hardhat test`.

4. Create an `.env` file in which mention "PVT_KEY=" and "RPC_URL="

5. Deploy to BSC testnet `npx hardhat run scripts/deploy.js --network bsctestnet`

Deployment address 

->Reward Token deployed at 0x725c0Ca68E2d9b0D08FCe4e5d1639144d1eC8D37

->NFT deployed at 0x0B66cfeAb696d67e588356aDdA482aA2328120A5

->STAKING deployed at 
 0x94726d8fdd8C62c83f64FE8d1bC4bCf115ee50d3
