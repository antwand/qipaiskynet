local skynet = require "skynet"
require "skynet.queue"
local logger = log4.get_logger(SERVICE_NAME)

local CS = skynet.queue()

local game_scene = require "app.config.game_scene"


local ONLINE_NUMBER = 0 --在线人数  



local CMD = {}



--登录验证 hall 的token 
function CMD.login_by_uid_token(msg,socket,fd)
    local uid =msg.uid
    local token = msg.token
    
    print(string.format("uid :%s ， token:%s, hall online :%s",uid,token,ONLINE_NUMBER));
    local result ;
    local closefd;
    
    
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local istrue = skynet.call(srv_token_login, "lua", "chanage_serverScene_by_uid_token", uid,token,game_scene.HallScene,socket,fd)
    if istrue then 
        result = code_utils.package(all_game_command.CMD.common_hall_login,code_error.OK,nil)
        ONLINE_NUMBER = ONLINE_NUMBER + 1
    else
        result = code_utils.package(all_game_command.CMD.common_hall_login,code_error.LOGIN_TOKEN_ERROR,nil)
        closefd = true;
    end
    
    return result,closefd;
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