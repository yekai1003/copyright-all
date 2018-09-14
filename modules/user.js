
var db = require("./db.js");

function User (user) {
      this.id = user.id;
      this.email = user.email;
      this.password = user.password;
      this.ethaccount = user.ethaccount;
}


User.findUser =function (email,password,callback) {
      var selectSql = "select * from user where email =?  and password = ?";

    db.query(selectSql,[email,password],function(error,result){
        if(error) {
            return callback(error);
        }
        callback(error,result);
     });
}

User.addUser = function (user,callback) {
      var selectSql = "insert into user (email,password,ethaccount) values (?,?,?)";

      db.query(selectSql,[user.email,user.password,user.ethaccount],function(error,result){
                if(error) {
                       return callback(error);
                }
                callback(error,result);
      });
}

module.exports = User;