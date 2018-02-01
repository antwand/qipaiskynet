
--[[
Action_READY.lua

 准备的action 操作  

]]
local skynet = require "skynet"


local game_action_type=  require "app.config.game_action_type"
local game_status=  require "app.config.game_status"


local config = import("...BAIJIALE.config.config_100")

local ROOM_HANDLE_PEOPLE = {};


local root = {}







--计时器启动  
root.init = function(rid,round)
    ROOM_HANDLE_PEOPLE[rid] = nil  
    
    --状态
    local status = game_status.BAIJIALE.WAIT
    round:change_status(status)
    
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_status,code_error.OK,{status = status})
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,result)
    
    
    --计时器 必须等真人完成 所以不需要计时器
    round.close_timeout()
    --[[
    local func = function()
            
    end
    local ti = config.bet_timeout
    round:create_timeout(ti, func)
    ]]
    
    return nil
end









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
    if index < config.desk_player_num then 
        return -1,room
    elseif index == config.desk_player_num then 
        --ROOM_HANDLE_PEOPLE[rid] = nil
        
        return 0,room
    else
        return 1,room
    end
    
    
    return 1,room
end












return root;