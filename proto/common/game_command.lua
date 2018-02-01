--[[

/**
 // 请求数据结构
 // 说明：所有的请求统一走公共的发送接口，以便做加密等处理
 var requestData = {
    "cmd" : "login", // 命令字
    d:{
        "uid" : "xxxx@qq.com", // 参数(随cmd变化（待开发时协商）)
        "token" : "123456"
    }
};

 // 响应数据结构
 // 说明：所有的响应数据应该由一个公共的接口处理，以便做解密、错误等处理
 var responseData = {
    "cmd" : "login", // 命令字(如果是同步请求，会原样返回请求的cmd，异步请求可能会返回其他的cmd)
    "ret" : 0, // 返回代码(0=成功，其他=失败时的错误代码（待定）)
    "msg" : "success", // 错误提示（调试用）
    "data" : { // 返回数据(随cmd变化（待开发时协商）)
        "id":"GIMXDpPzfJWFqL7XAAAA",
        "name" : "张三",
        "avatar" : "http://xxxxx.com/avatar/1.png",
        "gender":0,//男女
        "diamonds"：1000,//钻石
    }
};

 


 // 请求数据结构
 // 说明：所有的请求统一走公共的发送接口，以便做加密等处理
 var requestData = {
    "cmd" : "logout", // 命令字
    d:{
    }
};

 // 响应数据结构
 // 说明：所有的响应数据应该由一个公共的接口处理，以便做解密、错误等处理
 var responseData = {
    "cmd" : "logout", // 命令字(如果是同步请求，会原样返回请求的cmd，异步请求可能会返回其他的cmd)
    "ret" : 0, // 返回代码(0=成功，其他=失败时的错误代码（待定）)
    "msg" : "success", // 错误提示（调试用）
    "data" : { // 返回数据(随cmd变化（待开发时协商）)
    }
};







 // 创建房间请求数据
 var requestData = {
    "cmd" : "createRoom",
    "sn":1,//客户端标示
    d:{
        "gameId" : 101, // 游戏ID，具体定义参见game-id.js
        "opts":opts,//基础配置信息gameconfig 比如局数 是否轮庄等
    }
};

 // 创建房间响应数据
 var responseData = {
    "cmd" : "createRoom",
    "ret" : 0,
    "msg" : "success",
    "sn":1,
    "data" : {
        "id" : 100001, // 房间ID
        "pos" : 2, // 默认随机的座位编号[0,3]
        "opts":opts,  //基础配置信息gameconfig 比如局数 是否轮庄等

    }
};




 // 加入房间请求数据
 var requestData = {
    "cmd" : "joinRoom",
    d:{
        "id" : 100001, // 房间ID，固定为6位，有效范围为[100001,999999]
        "role" : 1, // 玩家角色(玩家/观看者)，具体参看player-role.js
        "sn":1,
    }
};

 // 加入房间响应数据
 var responseData = {
    "cmd" : "joinRoom",
    "ret" : 0,
    "msg" : "success",
    "sn":1,
    "data" : {
        "id":100001,//房间id
        "pos" : 2, // 默认随机的座位编号[0,3]
        "opts":opts,  //基础配置信息gameconfig 比如局数 是否轮庄等
        "seatPlayerIds":["GIMXDpPzfJWFqL7XAAAA","GIMXDpPzfJWFqL7XAAAA"] //用户的userid座位
        "playerInfos":{
            "GIMXDpPzfJWFqL7XAAAA":{
                "id":"GIMXDpPzfJWFqL7XAAAA",
                "name" : "张三",
                "avatar" : "http://xxxxx.com/avatar/1.png",
                "gender":0,//男女
                "diamonds"：1000,//钻石
            },
            "GIMXDpPzfJWFqL7XAAAA":{
                "id":"GIMXDpPzfJWFqL7XAAAA",
                "name" : "张三",
                "avatar" : "http://xxxxx.com/avatar/1.png",
                "gender":0,//男女
                "diamonds"：1000,//钻石
            }
        }
    }
};
 //加入房间的push到初自己之外的房间内其它玩家的数据
 var responseData = {
    "cmd" : "joinRoomPush",
    "ret" : 0,
    "msg" : "success",
    "data" : {
        "uid":
        "playerInfos":{
            "id":"GIMXDpPzfJWFqL7XAAAA",
            "name" : "张三",
            "avatar" : "http://xxxxx.com/avatar/1.png",
            "gender":0,//男女
            "diamonds"：1000,//钻石
        }
        "pos"：2，／／当前玩家所处的风位
    }
};









 // 离开房间请求数据  （注意1：群主离开房间怎么处理？？比如是否将群主转移到其它玩家，2：离开房间和关闭房间不一样）
 var requestData = {
    "cmd" : "leaveRoom"
};
 // 离开房间响应数据
var responseData = {
    "cmd" : "leaveRoom",
    "ret" : 0,
    "msg" : "success",
    "data" : {}
};
 //离开房间的push到初自己之外的房间内其它玩家的数据
 var responseData = {
    "cmd" : "leaveRoomPush",
    "ret" : 0,
    "msg" : "success",
    "data" : {
        pos:2,//当前离开房间人的风位
        id:"GIMXDpPzfJWFqL7XAAAA",//离开房间的用户userid   通过pos其实可以获取这个用户的uid
    }
};




 ／／关闭房间只能房主处理  相当于吧房间解散了
 var requestData = {
    "cmd" : "closeRoom"
};
 // 关闭房间响应数据
 var responseData = {
    "cmd" : "closeRoom",
    "ret" : 0,
    "msg" : "success",
    "data" : {}
};
 //关闭 房间的push到初自己之外的房间内其它玩家的数据
 var responseData = {
    "cmd" : "closeRoomPush",
    "ret" : 0,
    "msg" : "success",
    "data" : {

    }
};












 // ........ 游戏开始的逻辑 start ....................................



 ／／1 ===========
 // 更改准备状态请求数据
 var requestData = {
    "cmd" : "changeReadyStatus",
    d:{
        "status" : 1 // 准备状态，具体参看ready-status.js  0是为准备 1是准备
    }
};
 // 更改准备状态响应数据
 var responseData = {
    "cmd" : "changeReadyStatus",
    "ret" : 0,
    "msg" : "success",
    "data" : {
        "status" : 1 // 准备状态，具体参看ready-status.js  0是为准备 1是准备
    }
};
 // 更改准备状态响应数据 房间的push到除自己之外的房间内其它玩家的数据
 var responseData = {
    "cmd" : "changeReadyStatusPush",
    "ret" : 0,
    "msg" : "success",
    "data" : {
        pos:2,//当前更改状态的风位
        //id:"GIMXDpPzfJWFqL7XAAAA",//离开房间的用户userid  看看这个字段要不要，不要通过pos也可以获取到玩家的uid
        "status" : 1 // 准备状态，具体参看ready-status.js  0是为准备 1是准备
    }
};







//2 =========
 // 游戏动作请求数据
 var requestData = {
    "cmd" : "gameAction",
    "d":
    {
        "type" : 1, // 动作类型，具体参照对应游戏的action-type.js  =》     BET = 0; // 下注   SHOW = 1; // 发牌
        "param"{ //每个动作对应不同的param 比如如果type=0，那么param就存储下注的金额  如果type=1，那么param就存储牌

        }
    }
};

 // 游戏动作响应数据
 var responseData = {
    "cmd" : "gameAction",
    "ret" : 0,
    "msg" : "success",
    "data" : {
        "type" : 1, // 动作类型，具体参照对应游戏的action-type.js  =》     BET = 0; // 下注   SHOW = 1; // 发牌
        "param"{ //每个动作对应不同的param 比如如果type=0，那么param就存储下注的金额  如果type=1，那么param就存储牌

        }
    }
};
 // 游戏动作推送数据
 var gameActionPushData = {
    "cmd" : "gameActionPush",
    "ret" : 0,
    "msg" : "success",
    "data" : {
        "type" : 1, // 动作类型，具体参照对应游戏的action-type.js  =》     BET = 0; // 下注   SHOW = 1; // 发牌
        "pos" ：0//谁进行的操作 风位置
        "param"{ //每个动作对应不同的param 比如如果type=0，那么param就存储下注的金额  如果type=1，那么param就存储牌

        }
    }
};











 //3 =============
 // 更改游戏状态请求数据
 var requestData = {
    "cmd" : "changeGameStatus",
    d:{
        "status" : 1 // 游戏状态，具体参看game-status.js(仅支持开始，结束)   =》 WAIT = 0; // 等待状态(玩家可以加入离开等)  INIT = 1; // 初始化状态(发牌等)  STARTED = 2; // 已经开始(玩家不可以加入)  PAUSED = 3; // 已经暂停   ENDED = 4; // 已经结束(结算处理等)  CLOSED = 5; // 已经关闭
    }
};

 // 更改游戏状态响应数据
 var responseData = {
    "cmd" : "changeGameStatus",
    "ret" : 0,
    "msg" : "success",
    "data" : {

    }
};

 // 更改游戏状态推送数据
 var changeGameStatusPushData = {
    "cmd" : "changeGameStatusPush",
    "ret" : 0,
    "msg" : "success",
    "data" : {
        "status" : 2 // 变更后的状态，具体参看game-status.js
    }
};










**/

]]



local exports={}



 exports.CMD = {
    common_user_register="common_user_register",--//注册
    common_user_login="common_user_login", --// 登录
    common_user_login_third="common_user_login_third", --// 第三方登录
    --        loginThird="user_auth", --// 第三方登录
    --        logout="user_logout", --// 登出退出游戏


    common_hall_login = "common_hall_login", --大厅登录 
     common_hall_createRoom="common_hall_createRoom", -- 创建房间
    -- joinRoom="room_join", -- 加入房间
    -- closeRoomByOwner="room_close_owner",--群主解散房间
    -- closeRoomByPlayer="room_close_player", -- 其它人员关闭房间


     common_game_login = "common_game_login", --游戏登录 
     common_game_action = "common_game_action", --游戏操作
    -- gameAction="room_game_action" -- 游戏动作推送

    -- "changeReadyStatus"="changeReadyStatus", -- 更改准备状态(准备/取消准备)

    -- "enterRoom"="enterRoom", -- 进入房间
    -- "leaveRoom"="leaveRoom", -- 离开房间
    -- "chat"="chat", -- 聊天
    -- "changeSeat"="changeSeat", -- 更换座位
    -- "changeControlMode"="changeControlMode", -- 更改控制模式(托管/取消托管)
    -- "changeGameStatus"="changeGameStatus", -- 更改游戏状态(暂停/继续)
    -- "gameAction"="gameAction", -- 游戏动作(出牌/碰/吃/明杠/暗杠等)
}



---- 推送命令
exports.PUSHCMD = {
    common_push_system_heartbeat="common_push_system_heartbeat", --// 心跳包

    -- kickUserPush="on_user_kick", --踢人


    -- joinRoomPush="on_room_join", -- 进入房间推送(未完成)
    -- closeRoomByOwnerPush="on_room_close_owner",--群主解散房间
    -- closeRoomByPlayerPush="on_room_close_player", -- 其它人员关闭房间


     common_push_game_init="common_push_game_init",
     common_push_game_action="common_push_game_action", -- 游戏动作推送
     common_push_game_status="common_push_game_status", -- 更改状态推送(未完成)
    -- gameInitPush="gameInitPush"-- 游戏初始化推送(初始牌推送等)



    -- "leaveRoomPush"="leaveRoomPush", -- 离开房间推送(未完成)
    -- "closeRoomPush"="closeRoomPush", -- 关闭房间推送(未完成)
    -- "chatPush"="chatPush", -- 聊天推送
    -- "changeSeatPush"="changeSeatPush", -- 更换座位推送(未完成)
    -- "changeControlModePush"="changeControlModePush", -- 更改控制模式推送(未完成)
    -- "changeGameStatusPush"="changeGameStatusPush", -- 更改游戏状态推送
    -- "gameInitPush"="gameInitPush", -- 游戏初始化推送(初始牌推送等)
    --
    -- "roundEndPush"="roundEndPush",--一局结束
    -- "gameEndPush"="gameEndPush",//所有局结束
};


return exports
