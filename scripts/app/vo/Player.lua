--[[
 用户属性  

]]
local player_type = require("app.config.player_type")
local Player = {}


function Player:new(uid,opts)
    local o = {
        uid = uid,
        token = opts.token,
        nickname = opts.nickname or "",
        gender = opts.gender, -- 性别
        avatar = opts.avatar, -- 头像
        diamonds = opts.diamonds or 0,--钻石
        roomCard = opts.roomCard or 0,--房卡
        score = opts.score or 0, --得分
        rid = opts.rid or nil,--房间 
        type = opts.type; --玩家类型 player_type
        
        onlineStatus = opts.onlineStatus, -- 是否在线
        readyStatus = opts.readyStatus, -- 游戏准备状态
        controlMode = opts.controlMode, -- 游戏控制模式
        
        loginTime = nil, --登录时间(毫秒)
        logoutTime = nil, --登出时间(毫秒)
        socket = nil, --socket连接
        fd = nil,--socket连接的fd
        serverScene = nil,--当前玩家所在的服务器场景 
       
    }
    setmetatable(o, {__index = self})
    return o
end

    



function Player:tostring( ... )
    local o =  {
        uid = self.uid,
        token = self.token,
        nickname = self.nickname or "",
        gender = self.gender, -- 性别
        avatar = self.avatar, -- 头像
        diamonds = self.diamonds or 0,
        roomCard = self.roomCard or 0,
        score = self.score or 0,
        rid = self.rid or nil,
        type = self.type, --玩家类型
        
        controlMode = self.controlMode, -- 游戏控制模式
        serverScene = self.serverScene,--当前玩家所在的服务器场景 
    }
    return o
end



function Player:reload(opt)
    self.uid = opt.uid
    self.nickname = opt.nickname
    self.diamond = opt.diamond
    self.score = opt.score
    self.online = false
end


--[[
/**
 * 获取玩家ID
 * @return {Number}
]]
function Player:getUid () 
    return self.uid;
end

--[[
/**
 * 获取玩家token
 * @return {String}
]]
function Player:getToken () 
    return self.token;
end


--[[
 * 获取玩家当前所在的服务器创建
 * @return 
]]
function Player:getServerScene  () 
    return self.serverScene;
end
function Player:setServerScene  (serverScene) 
    self.serverScene = serverScene;
end




--[[
 * 绑定socket
 * @param {socket} socket
 ]]
function Player:bindSocket  (socket,fd) 
    self.socket = socket;
    self.fd = fd;
end

--[[
 * 获取绑定的socket
 * @return {socket|null}
]]
function Player:getBindSocket  () 
    return self.socket;
end

--[[
 * 取消socket绑定
]]
function Player:unbindSocket  () 
    self.socket = nil;
end
function Player:getfd  (rid) 
    return self.fd ;
end





--[[
设置房间id 
]]
function Player:setRid  (rid) 
    self.rid = rid;
end


--[[
 * 是否是机器人
 * @return {Boolean}
]]
function Player:isRobot () 
    return (self.type == player_type.ROBOT);
end


return Player