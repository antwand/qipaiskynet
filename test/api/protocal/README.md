# 协议 API 使用指南


```
// protocal.js  - in progress

// 初始化协议
// schema - 协议内容，是一个lua dump 出的文件，从文件读取的buffer
// sender - 发送器，一般是 websocket.send
// receiver - 接受器, 外部一般调用 websocket.on('message', receiver)
protocal.init(schema, sender, receiver);


// 客户端发送消息, 并等待返回结果
protocal.login(params, callback)


// 服务端推送消息处理 
protocal.on('refreshCards', callback);

```







