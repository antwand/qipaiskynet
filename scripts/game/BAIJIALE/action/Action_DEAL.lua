
--[[
Action_DEAL.lua

发牌操作 

]]
local game_action_type=  require "app.config.game_action_type"
local skynet = require "skynet"
local config = import(".config.config_100")



local root = {}






--计时器启动  
root.init = function(rid,round)
    local func = function(masterPlayer)
        root.init(nil,rid,nil,nil,nil,round);
    end
    local ti = config.reset_card_timeout
    round.create_timeout(ti, func)
    
    return nil
end








--处理 
root.handle = function(uid,rid,msg,socket,fd,round)
    
    --吧所有玩家的百家乐牌  发出去 
--    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
--    
--    
--    --room
--    local room = skynet.call(srv_hall_room, "lua", "getRoomByRoomId", rid)
--    
--    
--    --skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,data,uid)
    
    return true
end












return root;