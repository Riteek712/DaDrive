// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
import "hardhat/console.sol";
contract DaDrive{
    struct Access{
        address user;
        bool access;
    }
    mapping(address=>string[]) value;
    //to store the url

    mapping(address=> mapping(address => bool)) ownership;
    //store the ownership status of diffrent files

    mapping(address => Access[]) accessList;
    mapping(address=> mapping(address=>bool)) previousData;

    function add(address _user, string calldata url) external{
        value[_user].push(url);
    }

    function allow(address _user) external{
        ownership[msg.sender][_user] = true;
        if(previousData[msg.sender][_user]==true){
            for(uint i = 0; i<accessList[msg.sender].length;i++){
                if(accessList[msg.sender][i].user == _user){
                    accessList[msg.sender][i].access = true;
                }
            }
        }else{
            accessList[msg.sender].push(Access(_user, true));
            previousData[msg.sender][_user] = true;
        }
        
    }

    function disallow( address _user) external{
        ownership[msg.sender][_user] = false;
        for(uint i = 0; i<accessList[msg.sender].length;i++){
            if(accessList[msg.sender][i].user == _user){
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address _user) external view returns(string[] memory){
        require(
            _user == msg.sender || ownership[_user][msg.sender],
            "You do not have the access."     
        );
        return value[_user];
    }

    function shareAccess() public view returns( Access[] memory){
        return accessList[msg.sender];
    }
}