
--[[
ActionHelper_CLOSED.lua

整个牌局房间结束  

]]

local player_type = require("app.config.player_type")
local game_action_type=  require "app.config.game_action_type"
local control_mode=  require "app.config.control_mode"
local config = import("...BAIJIALE.config.config_100")


local skynet = require "skynet"




local root = {}




--计时器启动  
root.init = function(rid,round)
    --状态
    local status = game_status.BAIJIALE.CLOSED
    round:change_status(status)
    
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_status,code_error.OK,{status = status})
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,result)
    
    
    --马上关闭并回收房间
    round:close();
    skynet.call(srv_hall_room, "lua", "closeRoom", rid)
    
    
    return nil
end







return root;