
--[[
Action_DEAL.lua

发牌操作 

]]
local skynet = require "skynet"

local game_action_type=  require "app.config.game_action_type"
local game_status=  require "app.config.game_status"

local config = import("...BAIJIALE.config.config_100")
local ActionHelper_ENDED=  require "game.BAIJIALE.actionpush.ActionHelper_ENDED"



local root = {}




--计时器启动  
root.init = function(rid,round)
    --状态
    local status = game_status.BAIJIALE.DEAL
    round:change_status(status)
    
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_status,code_error.OK,{status = status})
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,result)
    
    
    --发牌 todo 
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_round_player_poker,code_error.OK,{round_player_poker = round:get_open_round_player_poker()})
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,result)
    
    
    --计时器
    local func = function(masterPlayer)    
        ActionHelper_ENDED.init(rid,round);
    end
    local ti = config.deal_card_timeout
    round:create_timeout(ti, func)
    
    
    return nil
end



--处理 
root.hanle = function()


end







return root;