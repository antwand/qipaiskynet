
--[[
Action_RESET_CARD.lua

  切牌 洗牌  的action 操作  

]]

local player_type = require("app.config.player_type")
local game_action_type=  require "app.config.game_action_type"
local control_mode=  require "app.config.control_mode"
local config = import("...BAIJIALE.config.config_100")

local Action_BET =  require "game.BAIJIALE.action.Action_BET"


local skynet = require "skynet"


local ROOM_HANDLE_PEOPLE = {};


local root = {}





--计时器启动  
root.init = function(rid,round)
    --下一家出牌的回调 
    local func = function(masterPlayer)
        --ai出牌 
        Action_BET.init(rid,round);
        
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
    
    
    
    
    --记录当前多少人准备了
    if ROOM_HANDLE_PEOPLE[rid] == nil  then 
        ROOM_HANDLE_PEOPLE[rid] = {};
    end
    local index = #(ROOM_HANDLE_PEOPLE[rid]) +1;
    ROOM_HANDLE_PEOPLE[rid][index] = uid;
    
    
    
    
    --人数 
    local room = skynet.call(srv_hall_room, "lua", "getRoomByRoomId", rid)
    if index == 4 then 
        round.close_timeout();
        ROOM_HANDLE_PEOPLE[rid] = nil
        
        return true,room
    end
    
    
    return nil
end












return root;