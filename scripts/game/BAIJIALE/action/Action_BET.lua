
--[[
Action_BET.lua

下注操作 

]]
local game_action_type=  require "app.config.game_action_type"
local skynet = require "skynet"
local config = import("...BAIJIALE.config.config_100")

local Action_DEAL =  require "game.BAIJIALE.action.Action_DEAL"

local root = {}






--计时器启动  
root.init = function(rid,round)
    --下一家出牌的回调 
    local func = function(masterPlayer)
        --ai出牌 
        Action_DEAL.init(rid,round);
        
    end
    local ti = config.reset_card_timeout
    round.create_timeout(ti, func)
    
    return nil
end








--处理 
root.handle = function(uid,rid,msg,socket,fd,round)
    --房间信息取出来 广播
    local data = {
        action = msg.action,
        param = msg.param,
        uid = uid,
    }
    local result = code_utils.package(all_game_command.CMD.common_game_action,code_error.OK,data)
    
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,data,uid)
    
    
    --给自己回复消息
    local result = result;
    result.sn = msg.sn;
    result.type = "RESPONSE"
    skynet.call(socket, "lua", "send",fd,cjson_encode(result))
    
    
    
    --room
    local room = skynet.call(srv_hall_room, "lua", "getRoomByRoomId", rid)
    
    
    
    return true
end












return root;