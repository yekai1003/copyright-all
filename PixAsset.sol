pragma solidity^0.4.20;

import "./PixCoin.sol";
contract ERC721 {
    //返回代币的数量
     function totalSupply() public view returns (uint256 total);
    //返回指定的地址_owner的非同质代币的数量
    function balanceOf(address _owner) public view returns (uint256 balance);
    //返回_tokenId非同质代币的拥有者的地址
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    //将tokenId非同质代币授权给地址to的拥有者
    //approve()方法的目的是可以授权第三人来代替自己执行交易
    function approve(address _to, uint256 _tokenId) external;
    // 将tokenId非同质代币转移给地址为to的拥有者
    function transfer(address _to, uint256 _tokenId) external;
    //从from拥有者转移tokenId非同质代币给_to新的拥有者
    //内部调用transfer方法进行转移
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    //Events
    //两个事件来分别记录转移和授权
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);
}

contract PixAssert is ERC721 {
    //币的编号
    string public constant name = "PixAssert";
     //币的别名
    string public constant symbol = "PXA";
    //根指定的地址返回代币的数量
    mapping(address=>uint)  _blanceOf;
     //记录代币是否拥有转移的权利
    mapping(uint=>address) _approve;
    //根据tokenId 找到资产的拥有者
    mapping(uint=>address) _owner;
    struct Asset {
         string contenthash;
         uint price;
         uint weigth;
         string metadata;
         uint voteCount;
    }
    address _function;
    PixCoin pixCoin;
    function PixAssert(address addr) {
        _function = addr;
        pixCoin = PixCoin(addr);
    }
    Asset  []  assets;
    //代币的数量
    function totalSupply() public view returns (uint256 total){
         total = assets.length;
    }
    // 返回指定的地址_owner的非同质代币的数量
    function balanceOf(address _owner) public view returns (uint256 balance){
            balance = _blanceOf[_owner];
    }
    // 返回_tokenId非同质代币的拥有者的地址
    function ownerOf(uint256 _tokenId) external view returns (address owner){
        owner = _owner[_tokenId];
    }
    // 将tokenId非同质代币授权给地址to的拥有者
     function approve(address _to, uint256 _tokenId) external {
          //_approve[_tokenId] = _to;
           approveAsset(_to, _tokenId);
     }

     function approveAsset(address _to, uint256 _tokenId) private {
           _approve[_tokenId] = _to;
     }



     //将tokenId非同质代币转移给地址为to的拥有者
     function transfer(address _to, uint256 _tokenId) external {
             //代币的拥有者必须等于当前调用者
             require(_owner[_tokenId] == msg.sender);
             //代币的 编号需要小于总量
             require(_tokenId<totalSupply());
             //当前代币拥有者的数量--
             _blanceOf[msg.sender]--;
             //转移的地址的数量++
             _blanceOf[_to]++;
             //删除授权
             delete _approve[_tokenId];
              //转移具体的拥有权
             _owner[_tokenId] = _to;
     }

     function transferFrom(address _from, address _to, uint256 _tokenId) external {
          _transferFrom(_from,_to,_tokenId);
     }

     function _transferFrom(address _from, address _to, uint256 _tokenId) private {
          //代币的 编号需要小于总量
          //代币的 编号需要小于总量
           require(_tokenId < totalSupply());
           //当前tokenId 必须属于 _from
           require(_owner[_tokenId] == _from);
           //tokenId 必须已经授权
           require(_approve[_tokenId] == _to);
           //当前代币拥有者的数量--
           _blanceOf[_from] --;
             //转移的地址的数量++
           _blanceOf[_to] ++;
           //删除授权
           delete _approve[_tokenId];
             //转移具体的拥有权
           _owner[_tokenId] = _to;

    }

     function _newAsset(string _contenthash,uint _price,uint _weight,string _metadata,uint _voteCount,address _uploadAddress) private {

            uint  _tokenId = assets.push(Asset(_contenthash,_price,_weight,_metadata,_voteCount));

           _owner[_tokenId] = _uploadAddress;

           _blanceOf[_uploadAddress]++;

     }

     function getTokenId(string _contenthash) public view returns(uint _tokenId) {
            for(uint i=0;i<assets.length;i++) {
                  if(keccak256(assets[i].contenthash) == keccak256(_contenthash)){
                            _tokenId = i;
                  }
            }
     }

     function newAsset(string _contenthash,uint _price,string _metadata) public{
            _newAsset(_contenthash,_price,100,_metadata,0,msg.sender);
     }

     function bid(uint _price,address _to, uint _tokenId,address _from) {
           approveAsset(_to,_tokenId);
           _transferFrom(_from,_to,_tokenId);
           pixCoin.approve(_to,_price);
           pixCoin.transferFrom(_to,_from,_price);
     }

     function vote(uint _tokenId,uint _price) public {
           require(_tokenId < totalSupply());

           Asset memory asset = assets[_tokenId];

           asset.voteCount++;

           pixCoin.transfer(_function,_price);
     }


}