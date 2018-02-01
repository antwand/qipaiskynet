local skynet = require "skynet"
require "skynet.queue"
local logger = log4.get_logger(SERVICE_NAME)

local CS = skynet.queue()

local game_scene = require "app.config.game_scene"
local Player_list = require "app.vo.Player_list"


local ONLINE_NUMBER = 0 --在线人数  



--通过token 获取player对象 
local function getPlayerByToken(token)
    --为连接数据库  先假定一个用户
    local uid = "GIMXDpPzfJWFqL7XAAAA"
    local data={
        uid = uid,
        name="赵四",
        avatar="http://img6.bdstatic.com/img/image/smallpic/touxiang1227.jpeg",
        token=token,
        diamonds = 100,
        gender=1,
        serverScene = game_scene.LoginScene,  --记录当前用户在哪个服务器 
    }
    
    return data
end










local CMD = {}

--登录 
function CMD.login_by_token(token,secret)
    local data = getPlayerByToken(token)
    if not data then 
        return nil
    end
    
    local uid = data.uid;
    local player =  Player_list.getPlayerByPlayerId(uid);
    if player then
        CMD.logout_by_uid(uid);
    end
    
    
    player = Player_list.setPlayer(data);
    ONLINE_NUMBER = ONLINE_NUMBER + 1
    
         
    return player:tostring();
end






--登出 踢人
function CMD.logout_by_token(token)
    local data = getPlayerByToken(token)
    if not data then 
        return nil
    end
    
    local uid = data.uid;
    CMD.logout_by_uid(uid)
end
function CMD.logout_by_uid(uid)
    local player =  Player_list.getPlayerByPlayerId(uid);
    if player then
        local serverScene = player:getServerScene();
        
        if serverScene == game_scene.LoginScene then
        elseif serverScene == game_scene.HallScene then
        elseif serverScene == game_scene.LobbyScene then
        elseif serverScene == game_scene.FightScene then
        end
        
        ONLINE_NUMBER = ONLINE_NUMBER - 1
    end
end



--验证token 
function CMD.check_by_token(token)
    local data = getPlayerByToken(token)
    if not data then 
        return nil
    end
    
    local uid = data.uid;
    return CMD.check_by_uid_token(uid,token);
end
function CMD.check_by_uid_token(uid,token)
    local player =  Player_list.getPlayerByPlayerId(uid);
    if player and player:getToken() == token then
        return true
    end
    return false
end






--[[
 先验证用户是否正确
 然后在更换当前用户所在的场景 
]]
function CMD.chanage_serverScene_by_uid_token(uid,token,scene,socket,fd)
    local ret = CMD.check_by_uid_token(uid,token)
    if ret == true then 
        local player =  Player_list.getPlayerByPlayerId(uid); 
        
        --如果之前的服务器还建立着连接 先断掉  始终保持一个长链接
        if player:getBindSocket() then
            skynet.call(player:getBindSocket(), "lua", "close", player:getfd())
        end

        --在判断场景是否正确
        player:setServerScene(scene);
        player:bindSocket(socket,fd);
        
        return true
    end
    
    return false
end



--判断某个用户是否已经登录 
function CMD.is_login(uid)
    local player =  Player_list.getPlayerByPlayerId(uid);
    if player then
        return true
    end
    return false
end

--通过某个用户uid 获取其 player
function CMD.get_player_by_uid(uid)
    local player =  Player_list.getPlayerByPlayerId(uid);
    
    if player then 
        return player:tostring();
    end
    
    return nil;
end









-------------- room 设置 --------------------------------------------------------------
function CMD.setRidWithUid(rid,uid)
    local player =  Player_list.getPlayerByPlayerId(uid);
    
    if player then 
        
        player:setRid(rid)
        return true
    end
    return false;
end
function CMD.ExitRoomWithUid(uid)
    local player =  Player_list.getPlayerByPlayerId(uid);
    if player then 
    
        if player:getBindSocket() then
            skynet.call(player:getBindSocket(), "lua", "close", player:getfd())
        end
        
        --退出房间 默认回到大厅
        player:setServerScene(game_scene.HallScene);
        player:bindSocket(nil,nil);
        player:setRid(nil)
        return true
    end
    return false;
end








-------------- 广播消息 --------------------------------------------------------------
--发送消息 
function CMD.sendMsg(uid,msg)
    local player =  Player_list.getPlayerByPlayerId(uid);
    if player then 
        skynet.call(player:getBindSocket(), "lua", "send", player:getfd(),msg)
        return true
    end
    return false;
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