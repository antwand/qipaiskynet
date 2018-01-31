local skynet = require "skynet"
require "skynet.queue"
local logger = log4.get_logger(SERVICE_NAME)

local CS = skynet.queue()

local game_scene = require "app.config.game_scene"
local Round_list = require "app.vo.Round_list"

local game_action_type=  require "app.config.game_action_type"
local game_status = require "app.config.game_status" 
local config = require "game.BAIJIALE.config.config_100"

local Action_READY=  require "game.BAIJIALE.action.Action_READY"
local Action_RESET_CARD =  require "game.BAIJIALE.action.Action_RESET_CARD"
local Action_BET =  require "game.BAIJIALE.action.Action_BET"

 
local ActionHelper_GameInit=  require "game.BAIJIALE.actionhelper.ActionHelper_GameInit"





 
local CMD = {}






-- 创建某一局的桌子 
function CMD.initByRoom(rid)
    return Round_list.initByRoom(rid);
end







-- gameaction
function CMD.gameAction(msg,socket,fd)
    local result ;
    local closefd;
    
    
    --判断是否有这个用户 
    local srv_game_login = skynet.call("srv_center", "lua", "getOneServer", "srv_game_login")
    local uid = skynet.call(srv_game_login, "lua", "getUidByFd", fd)
    if not uid  then 
        result =  code_utils.package(all_game_command.CMD.common_game_action,code_error.LOGIN_IS_OFFLINE,nil)
        return result
    end
    
    
    
    
    --在判断用户是否在战斗场景 
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local player = skynet.call(srv_token_login, "lua", "get_player_by_uid", uid)
    if player.serverScene ~= game_scene.FightScene  then 
        
        result = code_utils.package(all_game_command.CMD.common_game_action,code_error.INVALID_PARAM,nil)
        closefd = true;
        
        return result,closefd;
    end
    
    
    
    
    
    local rid = player.rid;--房间rid 
    local round = nil;
    
    --action
    local action = tostring(msg.action);
    if action == tostring(game_action_type.BAIJIALE.READY) then --准备，必须有人发  否则不会开始 
        local isfull,room = Action_READY.handle(uid,rid,msg,socket,fd);
        if isfull == true then --满人
            round = CMD._createRound(room);
            ActionHelper_GameInit.push_all(round);
            
            Action_RESET_CARD.init(rid,round);
        end
        
    elseif action == tostring(game_action_type.BAIJIALE.RESET_CARD) then --切牌 
        round = CMD.getRoundByRoundId(rid);
        local isfull,room = Action_RESET_CARD.handle(uid,rid,msg,socket,fd,round);
        if isfull == true then --满人
            
            
        end
        
    elseif action == tostring(game_action_type.BAIJIALE.BET) then --下注 
        round = CMD.getRoundByRoundId(rid);
        local issuccess = Action_BET.handle(uid,rid,msg,socket,fd,round);
    
    elseif action == tostring(game_action_type.BAIJIALE.BET) then --发牌 
        round = CMD.getRoundByRoundId(rid);
        local issuccess,room = Action_BET.handle(uid,rid,msg,socket,fd,round);
    else
        
    
    end
    
    
    return result,closefd;
end




--// private
CMD.getRoundByRoundId = function(roomid,idx)
    local round = Round_list.getRoundByRoundId(roomid,idx)
    
    
    return round;
end








--创建round 
function CMD._createRound(room)
    local rid = room.rid;
    local round = Round_list.getRoundByRoundId(rid)
    if round then 
        local idx = #round+1
        local masterId = room.masterId;
        local seat_uid_list = room.seat_uid_list  -- 坐下的玩家 
        local watcher_uid_list = room.watcher_uid_list  -- 观察玩家
        local status = game_status.BAIJIALE.WAIT;
        
        
        local round = Round_list.setRound(rid,idx,{masterId = masterId,status=status,seat_uid_list = seat_uid_list,watcher_uid_list = watcher_uid_list});
        
        return round;
    end
    
    return nil;
end










function CMD.info()
    -- TODO
end







skynet.start(function() 
    skynet.dispatch("lua", function(session, _, command, ...)
        local f = CMD[command]
        if not f then
            if session ~= 0 then
                skynet.ret(skynet.pack(nil))
            end
            return
        end
        if session == 0 then
            return CS(f, ...)
        end
        skynet.ret(skynet.pack(CS(f, ...)))
    end)
end)