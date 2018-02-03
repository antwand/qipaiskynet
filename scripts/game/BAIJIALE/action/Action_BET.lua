
--[[
Action_BET.lua

下注操作 

]]
local game_action_type=  require "app.config.game_action_type"
local game_status=  require "app.config.game_status"

local skynet = require "skynet"
local config = import("...BAIJIALE.config.config_100")

local Action_DEAL =  require "game.BAIJIALE.action.Action_DEAL"

local root = {}






--计时器启动  
root.init = function(rid,round)
    --状态
    local status = game_status.BAIJIALE.BET
    round:change_status(status)
    
    local result = code_utils.package(all_game_command.PUSHCMD.common_push_game_status,code_error.OK,{status = status})
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,result)
    
    
    
    
    --计时器
    local func = function()
        print("倒计时完毕");
       Action_DEAL.init(rid,round);
    end
    local ti = config.bet_timeout
    round:create_timeout(ti, func)
    
    return nil
end








--处理 
root.handle = function(uid,rid,msg,socket,fd,round)
    local sendMe = function(endData)
        endData.sn = msg.sn;
        endData.type = "RESPONSE"
        skynet.call(socket, "lua", "send",fd,cjson_encode(endData))
    end
    

    local data = {
        action = msg.action,
        param = msg.param,--{bet_num:}
        uid = uid,
    }
    --判断用户的下注码够不够 
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local player = skynet.call(srv_token_login, "lua", "get_player_by_uid", uid)
    local currentbet = checkint(msg.param.bet_num);
    if currentbet < 0 or currentbet > checkint(player.diamonds) then 
        local result = code_utils.package(all_game_command.CMD.common_game_action,code_error.NO_DIAMONDS,data)
        sendMe(result);
        return;
    end
    

    --房间信息取出来 广播
    local result = code_utils.package(all_game_command.CMD.common_game_action,code_error.OK,data)
    local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
    skynet.call(srv_hall_room, "lua", "broadcastRoom", rid,result,uid)
    
    
    --给自己回复消息
    result.cmd = all_game_command.CMD.common_game_action
    sendMe(result);
    
    
    return true
end












return root;