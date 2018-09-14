var express = require('express');
var path = require('path');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('express-session');

//自己编写的文件
//var user=require("./router/user");
var test=require("./router/test");

var user=require("./router/user");
var asset=require("./router/asset");
var autcion=require("./router/auction");
var file=require("./router/file");


var app = express();
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));


app.use(session({
    secret: 'csdn-secret',
    name: 'csdn-name',
    cookie: { maxAge: 8000000000 },
    resave: false,
    saveUninitialized: true,
}));

app.use("/user",user);
app.use("/asset",asset);
app.use("/auction",autcion);
app.use("/file",file);



app.use(function (req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

if (app.get('env') === 'development') {
    app.use(function (err, req, res, next) {
        res.status(err.status || 500);
        res.send({
            message: err.message,
            error: err
        });
    });
}
app.use(function (err, req, res, next) {
    res.status(err.status || 500);
    res.send({
        message: err.message,
        error: err
    });
});

module.exports = app;
