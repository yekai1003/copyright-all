var express=require("express");
var router = express.Router();

//引入web3.js
var Web3=require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));
// var abi=""
// var address="0xa01c414cf5fa020f9a2488caef1441a70079fefb";
//
// //调用web3 去获取到合约的对象
//
// var message = new web3.eth.Contract(abi,address);
/*注册*/
router.get("/getAccount",function(req,resp){
    //准备创建资产的
    router.get("/newAsset",function(req,resp){
        //找数据
        //解锁用户.
        unlock("0x022f290578d83b4b49708b3f8a691569cfb634cf","123456",function(){

            csdn.methods.newAsset("csdn001",100,"csdn0002").send({from:"0x022f290578d83b4b49708b3f8a691569cfb634cf",gas:300000}).then(function(result){
                csdn.methods.getTokenId("cccccc").call(function(error,result){
                    var asset = new Asset({
                        lifephoto:"../csdn.jpg",
                        pixprice:200,
                        userId:1,
                        contenthash:"cccccc",
                        tokenId:result,
                        weight:100,
                        voteCount:0,
                        createTime:new Date()
                    });
                    Asset.addAsset(asset,function(error,result){
                        console.log(error);
                        console.log("=================");
                        console.log(result);
                    });

                })
            });
        })
    });
    router.get("/vote",function(req,resp){
        console.log("www");
        unlock("0x022f290578d83b4b49708b3f8a691569cfb634cf","123456",function(){
            csdn.methods.vote(1,9).send({from:"0x022f290578d83b4b49708b3f8a691569cfb634cf",gas:300000}).then(function(result){
                //更新数据库.
                Asset.updateAsset(2,3,function(error,result){
                    console.log("投票成功");
                })
            });
        })
    });


    web3.eth.personal.newAccount("123456",function (error,result) {
         resp.send(result);
    })

});
module.exports = router;
