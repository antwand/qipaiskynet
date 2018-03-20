const protocalCore = require('./protocal-core');


const Protocal = {
    load(name,callback){
        var self = this;

        var newpath = "SPROTO/" +name;
        cc.loader.loadRes(newpath, function (err, data) {
            if(err){
                cc.log(err)
            }else{
                if(callback){
                    callback(data);
                }
            }
        });
    },

    // 初始化协议
    // schema - 获取的协议
    // sender - Websocket.send
    // writer - Websocket.on('message', writer);
    init(schema, sender, writer) {
        protocalCore.init(schema, sender, writer);
    },

    // 发送消息
    send(cmd,args, callback) {
        protocalCore.send(cmd, args, callback);
    },


    // 监听服务端推送消息
    on(command, callback) {
        protocalCore.on(command, callback);
    },




    // 客户端发送给服务端的命令
    // 根据协议内容自动添加

    // 登陆消息
    login(args, callback) {
        this.send('login', args, callback);
    },
}


export default Protocal
