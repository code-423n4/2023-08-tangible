// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;
interface IVePearl {

    struct Point {
        int128 bias;
        int128 slope; // # -dweight / dt
        uint256 ts;
        uint256 blk; // block
    }

    // struct LockedBalance {
    //     int128 amount;
    //     uint end;
    // }

    function create_lock_for(uint _value, uint _lock_duration, address _to) external returns (uint);

    // function locked(uint id) external view returns(LockedBalance memory);
    function locked(uint id) external view returns(int128 amount, uint end);
    function tokenOfOwnerByIndex(address _owner, uint _tokenIndex) external view returns (uint);

    function token() external view returns (address);
    function team() external view returns (address);
    function epoch() external view returns (uint);
    function point_history(uint loc) external view returns (Point memory);
    function user_point_history(uint tokenId, uint loc) external view returns (Point memory);
    function user_point_epoch(uint tokenId) external view returns (uint);

    function ownerOf(uint) external view returns (address);
    function isApprovedOrOwner(address, uint) external view returns (bool);
    function transferFrom(address, address, uint) external;

    function voted(uint) external view returns (bool);
    function attachments(uint) external view returns (uint);
    function voting(uint tokenId) external;
    function abstain(uint tokenId) external;
    function attach(uint tokenId) external;
    function detach(uint tokenId) external;

    function checkpoint() external;
    function deposit_for(uint tokenId, uint value) external;

    function balanceOfNFT(uint _id) external view returns (uint);
    function balanceOf(address _owner) external view returns (uint);
    function totalSupply() external view returns (uint);
    function supply() external view returns (uint);


    function decimals() external view returns(uint8);

    function create_lock(uint _value, uint _lock_duration) external returns(uint);
    function withdraw(uint _tokenId) external;
    function increase_amount(uint _tokenId, uint _value) external;
    function increase_unlock_time(uint _tokenId, uint _lock_duration) external;
    function merge(uint _from, uint _to) external;
    function split(uint[] memory amounts, uint _tokenId) external;
    function approve(address _approved, uint _tokenId) external;
}