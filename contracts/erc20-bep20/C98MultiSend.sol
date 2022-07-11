pragma solidity ^0.4.23;

/**
 * @title BEP20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract BEP20 {
    uint public _totalSupply;
    function totalSupply() public view returns (uint);
    function balanceOf(address who) public view returns (uint);
    function transfer(address to, uint value) public;
    function allowance(address owner, address spender) public view returns (uint);
    function transferFrom(address from, address to, uint value) public;
    function approve(address spender, uint value) public;
}

contract AuraNWMultisend {
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

    event transfer(address from, address to, uint amount,address tokenAddress);
    
    // Transfer multi main network coin
    // Example ETH, BSC, HT
    function transferMulti(address[] receivers, uint256[] amounts) public payable {
        require(msg.value != 0 && msg.value == getTotalSendingAmount(amounts));
        for (uint256 i = 0; i < amounts.length; i++) {
            receivers[i].transfer(amounts[i]*1e18);
            emit transfer(msg.sender, receivers[i], amounts[i]*1e18, WBNB);
        }
    }
    
    // Transfer multi token BEP20
    function transferMultiToken(address tokenAddress, address[] receivers, uint256[] amounts) public {
        require(receivers.length == amounts.length && receivers.length != 0);
        BEP20 token = BEP20(tokenAddress);

        for (uint i = 0; i < receivers.length; i++) {
            require(amounts[i] > 0 && receivers[i] != 0x0);
            token.transferFrom(msg.sender,receivers[i], amounts[i]*1e18);
        
            emit transfer(msg.sender, receivers[i], amounts[i]*1e18, tokenAddress);
        }
    }
    
    function getTotalSendingAmount(uint256[] _amounts) private pure returns (uint totalSendingAmount) {
        for (uint i = 0; i < _amounts.length; i++) {
            require(_amounts[i] > 0);
            totalSendingAmount += _amounts[i]*1e18;
        }
    }
}
