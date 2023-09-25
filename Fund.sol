 // SPDX-License-Identifier: GPL-3.0


pragma solidity >=0.7.0 <0.9.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{

    uint256 public minimumUsd = 2 ;
    address[] public funders;

    mapping( address => uint256 ) public addressToAmount;


    function getConversionRate() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
         (,int256 answer ,  , , ) = priceFeed.latestRoundData();
         return uint256(answer) ;
    }
    function fund() public payable returns(bool){
        require(getUsdToEth(msg.value) >= minimumUsd);
        funders.push(msg.sender);
        addressToAmount[msg.sender] = msg.value;
        return true;
    }
    function getUsdToEth(uint256 ethAmount ) public view returns(uint256){
         (,int256 answer ,  , , ) = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).latestRoundData();
         return  ethAmount * uint256(answer) ;

    }
    function returnNoFunders() public view returns(uint256){
        return funders.length;
    }
    function getFunder(uint256 _index) public view returns(address , uint256){
        return (funders[_index] , addressToAmount[funders[_index]]);
    }
    function getContractBalance() public view returns (uint256){
        return address(this).balance;
    }

}