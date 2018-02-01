
--[[
Action_READY.lua

 准备的action 操作  

]]
local game_action_type=  require "app.config.game_action_type"
local skynet = require "skynet"
local config = import("...BAIJIALE.config.config_100")

local ROOM_HANDLE_PEOPLE = {};


local root = {}


--处理 
root.handle = function(uid,rid,msg,socket,fd)
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
    
    
    
    --人数 人满了  那么开始初始化round 
    local room = skynet.call(srv_hall_room, "lua", "getRoomByRoomId", rid)
    if index == 4 then 
        ROOM_HANDLE_PEOPLE[rid] = nil
        
        return true,room
    end
    
    
    return nil
end












return root;