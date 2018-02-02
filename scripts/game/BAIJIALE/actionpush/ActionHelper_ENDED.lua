
--[[
ActionHelper_ENDED.lua

每一局结束

]]

local player_type = require("app.config.player_type")
local game_action_type=  require "app.config.game_action_type"
local control_mode=  require "app.config.control_mode"

local config = import("...BAIJIALE.config.config_100")
local ActionHelper_CLOSED=  require "game.BAIJIALE.actionpush.ActionHelper_CLOSED"
local Action_READY=  require "game.BAIJIALE.action.Action_READY"
local game_status=  require "app.config.game_status"

local skynet = require "skynet"




local root = {}




--计时器启动  
root.init = function(rid,round)
     --开始下注状态
    local status = game_status.BAIJIALE.ENDED
    round:change_status(status)
    
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_status,code_error.OK,{status = status})
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,result)
    
    
    
    --判断是否是最后一局 
    local roundid = round.roundid 
    if roundid >= config.max_round  then 
        ActionHelper_CLOSED.init(rid,round);
        return 
    end
    
    
    
    --计时器
    local func = function()  
        --清空旧局
        round:close();
        --重新开始新局
        local srv_game_action = skynet.call("srv_center", "lua", "getOneServer", "srv_game_action")
        skynet.call(srv_game_action, "lua", "initByRound", rid)
    end
    local ti = config.next_round_timeout
    round:create_timeout(ti, func)
    
    
    return nil
end







return root;