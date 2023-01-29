// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract staking is ReentrancyGuard, ERC1155Holder {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;
    IERC20 private immutable token;
    IERC1155 private immutable nft;

    uint256 constant oneMonthInSeconds = 2629743;

    uint256 constant denominator = 100 * oneMonthInSeconds * 12;
    struct StakingItem {
        address owner;
        uint256 tokenId;
        uint256 amount;
        uint256 stakingStartTimeStamp;
    }
    mapping(address => StakingItem) public stakers;
    mapping(address => mapping(uint256 => StakingItem)) public stakedNFTs;

    event Staked(
        address indexed owner,
        uint256 tokenId,
        uint256 amount,
        uint256 time
    );

    event Unstaked(
        address indexed owner,
        uint256 indexed tokenId,
        uint256 indexed amount,
        uint256 time,
        uint256 reward
    );

    constructor(IERC20 _tokenAddress, IERC1155 _nftAddress) {
        require(
            address(_tokenAddress) != address(0) &&
                address(_nftAddress) != address(0),
            "Contract addresses cannot be zero address."
        );
        token = _tokenAddress;
        nft = _nftAddress;
    }

    function calculateInterestRate(uint256) private view returns (uint256) {
        uint256 totalTime = stakers[msg.sender].stakingStartTimeStamp;

        if (block.timestamp - totalTime < oneMonthInSeconds) {
            return 0;
        } else if (block.timestamp - totalTime < 6 * oneMonthInSeconds) {
            return 5;
        } else if (block.timestamp - totalTime < 12 * oneMonthInSeconds) {
            return 10;
        } else {
            return 15;
        }
    }

    function calculateStakedTimeInSeconds(
        uint256 _timestamp
    ) private view returns (uint256) {
        return (block.timestamp - _timestamp);
    }

    function approveNFT(address _spender) external {
        require(
            nft.isApprovedForAll(msg.sender, address(this)) == false,
            "NFT already approved"
        );
        nft.setApprovalForAll(_spender, true);
    }

    function revokeNFTApproval(address _spender) external {
        require(
            nft.isApprovedForAll(msg.sender, address(this)) == true,
            "NFT not approved"
        );
        nft.setApprovalForAll(_spender, false);
    }

    function stakeNFT(uint256 _tokenId, uint256 _amount) external {
        require(
            nft.balanceOf(msg.sender, _tokenId) >= _amount,
            "Nft not enough to Stake"
        );
        require(
            nft.isApprovedForAll(msg.sender, address(this)) == true,
            "Contract is not approved"
        );
        require(
            _tokenId == 0 || _tokenId == 1 || _tokenId == 2,
            "Nft token Id doesn't exist"
        );

        uint256 currentTime = block.timestamp;

        stakedNFTs[msg.sender][_tokenId] = StakingItem(
            msg.sender,
            _tokenId,
            _amount,
            currentTime
        );

        nft.safeTransferFrom(msg.sender, address(this), _tokenId, _amount, "");
        emit Staked(msg.sender, _tokenId, _amount, currentTime);
    }

    function unStakeNFT(uint256 _tokenId, uint256 _amount) external {
        require(
            stakedNFTs[msg.sender][_tokenId].owner == msg.sender ||
                stakedNFTs[msg.sender][_tokenId].owner != address(0),
            "NFT not staked"
        );
        require(
            stakedNFTs[msg.sender][_tokenId].amount <= _amount,
            "You have less Nft"
        );
        require(
            nft.isApprovedForAll(msg.sender, address(this)) == true,
            "Contract not approves"
        );

        uint256 timestamp = stakedNFTs[msg.sender][_tokenId]
            .stakingStartTimeStamp;

        uint256 stakingPeriodTime = calculateStakedTimeInSeconds(timestamp);

        uint256 interestRate = calculateInterestRate(stakingPeriodTime);

        uint256 reward = (interestRate * _amount * stakingPeriodTime) /
            denominator;

        nft.safeTransferFrom(address(this), msg.sender, _tokenId, _amount, "");
        if (reward > 0) {
            token.safeTransfer(msg.sender, reward);
        }
        emit Unstaked(msg.sender, _tokenId, _amount, stakingPeriodTime, reward);
    }
}
