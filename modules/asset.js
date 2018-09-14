var db = require("./db.js");

function Asset (asset) {
       this.id = asset.id;
       this.lifephoto = asset.lifephoto;
       this.pixprice = asset.pixprice;
       this.userId = asset.userId;
       this.contenthash = asset.contenthash;
       this.tokenId = asset.tokenId;
       this.weight = asset.weight;
       this.voteCount = asset.voteCount;
       this.createTime = asset.createTime;
}

Asset.addAsset = function (asset,callback){
    var selectSql = "insert into asset (lifephoto,pixprice,userId,contenthash,tokenId,weight,voteCount,createTime) values (?,?,?,?,?,?,?,?)";
    db.query(selectSql,[asset.lifephoto,asset.pixprice,asset.userId,asset.contenthash,asset.tokenId,asset.weight,asset.voteCount,asset.createTime],function(error,result){
        if(error) {
            return callback(error);
        }
        callback(error,result);
    });
}

//查找到当前用户下面所有资产
Asset.findAsset = function (userId,callback) {
    var selectSql = "select * from asset where userId = ?";

    db.query(selectSql,[userId],function(error,result){
        if(error) {
            return callback(error);
        }
        callback(error,result);
    });
}


Asset.updateAsset = function (id,voteCount,callback){
    var selectSql = "update asset set voteCount = ? where id = ?";
    db.query(selectSql,[voteCount,id],function(error,result){
        if(error) {
            return callback(error);
        }
        callback(error,result);
    });
}

module.exports = Asset;