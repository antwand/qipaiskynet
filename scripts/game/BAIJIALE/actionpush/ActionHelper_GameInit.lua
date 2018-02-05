
--[[
ActionHelper_GameInit.lua

ActionHelper_GameInit 操作 

]]

local player_type = require("app.config.player_type")
local game_action_type=  require "app.config.game_action_type"
local control_mode=  require "app.config.control_mode"
local config = import("...BAIJIALE.config.config_100")
local game_status=  require "app.config.game_status"

local skynet = require "skynet"




local root = {}






--处理 分发给整桌所有  
root.push_all = function(round)
    local seat_uid_list = round.seat_uid_list -- 坐下的玩家 
    local watcher_uid_list = round.watcher_uid_list  -- 观察玩家
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    
    
    --百家乐的过程  直接切牌下注 
    
    --[[
    --一个倒计时开始读牌   这个是麻将的过程  需要下一家出牌 
    local ti = config.show_card_timeout
    local masterId = round.masterId;
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local master =  skynet.call(srv_token_login, "lua", "get_player_by_uid",masterId) 
    local controlMode = master.controlMode
    
    if master.type == player_type.ROBOT or master.controlMode == control_mode.BY_SYSTEM then --npc /系统控制 
        ti = math.random(1,config.ai_tick_interval)
    end 
    --下一家出牌的回调 
    local func = function(masterPlayer)
        
    end
    round.create_timeout(ti, func,master)
    ]]
    
    
    
    for k, v in pairs(seat_uid_list) do
        --分发给不同的玩家  
        local data = round:toClosestring(v);
        local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_init,code_error.OK,data)
        
        
        skynet.call(srv_hall_room, "lua", "broadcastByUid", v,result)
    end
    
    local data = round:toClosestring(nil);
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_init,code_error.OK,data)
    skynet.call(srv_hall_room, "lua", "broadcastByUids", watcher_uid_list,result)
    
    
    
    
    return nil
end






--分发给某一个玩家  断线重连或者第一次进入桌面的时候  发送给用户 
root.push_one = function(round,uid)
    local seat_uid_list = round.seat_uid_list -- 坐下的玩家 
    local watcher_uid_list = round.watcher_uid_list  -- 观察玩家
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    
    
    
    
    
    local isseat = false;
    for k, v in pairs(seat_uid_list) do
    
        if v == uid then
            isseat = true;
            
            local data = round:toClosestring(v);
            local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_init,code_error.OK,data)
            skynet.call(srv_hall_room, "lua", "broadcastByUid", v,result)
            
            return result;
        end
    end
    
    
    
    --如果自己不是坐着的玩家  
    local data = round:toClosestring(nil);
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_init,code_error.OK,data)
    skynet.call(srv_hall_room, "lua", "broadcastByUid", uid,result)
    
    
    return data
end






return root;