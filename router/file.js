/**
 * Created by cena on 2016/4/18.
 */
var express = require('express'),
    formidable = require('formidable'),
    fs = require('fs'),
    uuid = require('node-uuid'),
    router = express.Router();



router.post('/files',function (req, res) {
    console.log('===============');
    //创建表单上传
    var form = new formidable.IncomingForm();
    //设置编辑
    form.encoding = 'utf-8';
    //设置文件存储路径
    form.uploadDir = "public/upload/";
    //保留后缀
    form.keepExtensions = true;
    //设置单文件大小限制 2m
    form.maxFieldsSize = 2 * 1024 * 1024;
    //form.maxFields = 1000;  设置所以文件的大小总和
    form.parse(req, function (err, fields, files) {
        console.log(files.fileName.path);
        res.send({ "picName": files.fileName.path});
    });
});
module.exports=router;