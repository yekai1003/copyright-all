pragma solidity^0.4.20;

contract ERC20 {
    //获取总的发行量
    function totalSupply() constant returns (uint totalSupply);
    //查询账户余额
    function balanceOf(address _owner) constant returns (uint balance);
   // 发送Token到某个地址(转账)
    function transfer(address _to, uint _value)returns(bool success);
    //从地址from 发送token到to地址
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
    //允许_spender从你的账户转出token
    function approve(address _spender, uint _value)returns(bool success);
    //查询允许spender转移的Token数量
    function allowance(address _owner, address _spender) constant returns (uint remaining);
    //transfer方法调用时的通知事件
    event Transfer(address indexed _from, address indexed _to, uint _value);
    //approve方法调用时的通知事件
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}


contract PixCoin is ERC20 {
    //代币的名称
    string public name = "PixCoin";
    //代币的编号
    string public symbol = "PXC";
    //基金会地址
    address public fundation;
    uint public totalAirDrop;
    //总的代币数量.
    uint private _totalSupply  ;
    //指定的地址可以存放的余额
    mapping(address=>uint) _balance;
    //指定的地址可以从某个账号提取的余额
    mapping(address=>mapping(address=>uint)) _allowance;
    // 0.4.24 constructor
    function PixCoin(uint totalSupply, address _owner) public {
        _totalSupply = totalSupply;
        fundation = _owner;
        _balance[fundation] = 4200000;
        totalAirDrop = 0;
    }
    function airDrop(address _to, uint _value) public {
        assert( msg.sender == fundation );
        if( totalAirDrop + _value + _balance[fundation] > 0 &&
            totalAirDrop +_value + _balance[fundation] <= _totalSupply &&
            address(0) != _to
        ) {
            _balance[_to] += _value;
        }
    }
    function totalSupply() constant returns (uint totalSupply) {
        totalSupply = _totalSupply;
        return;
    }
    function balanceOf(address _owner) constant returns (uint balance) {
        return _balance[_owner];
    }
    function transfer(address _to, uint _value) returns (bool success) {
        // qian gou |
        //assert( _balance[msg.sender] >= _value );
        if( _balance[msg.sender] >= _value &&
            address(0) != _to  &&
            _balance[_to] + _value > 0
        ) {
            // how to do ? + he -
            _balance[msg.sender] -= _value;
            _balance[_to]  += _value;// if _to.val chao ji da > uint256
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        else {
            return false;
        }


    }
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        if( address(0) != _to &&
            _balance[_to] + _value > 0 &&
            _allowance[_from][_to] >= _value &&
            _balance[_from] >= _value
        ) {
            _allowance[_from][_to] -= _value;
            _balance[_to] += _value;
            _balance[_from] -= _value;
            // dui zhang对账
            //require(_balance[_to] + _balance[_from] = _allowance[_from][_to]);
            return true;
        }
        else {
            return false;
        }
    }
    function approve(address _spender, uint _value) returns (bool success) {
        if( _balance[msg.sender] >= _value &&
            address(0) != _spender
        ) {
            // shi fou qing 0 ?
            _allowance[msg.sender][_spender] = _value;
            emit Approval(msg.sender, _spender, _value);

        }
        else {
            return false;
        }
    }
    function allowance(address _owner, address _spender) constant returns (uint remaining) {
        return _allowance[_owner][_spender];
    }
    function getAddr() public view returns (address) {
        return address(this);
    }

}