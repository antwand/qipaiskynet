const protocalCore = require('./protocal-core');


const Protocal = {
    // 初始化协议
    // schema - 获取的协议
    // sender - Websocket.send
    // writer - Websocket.on('message', writer);
    init(schema, sender, writer) {
        protocalCore.init(schema, sender, writer);
    }


    // 客户端发送给服务端的命令
    // 根据协议内容自动添加

    // 登陆消息
    login(args, callback) {
        protocalCore.send('login', args, callback);
    }


    // 监听服务端推送消息
    on(command, callback) {
        protocalCore.on(command, callback);
    }
}


export default Protocal
