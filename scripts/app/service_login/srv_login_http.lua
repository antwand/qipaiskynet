local skynet = require "skynet"
require "skynet.queue"
local logger = log4.get_logger(SERVICE_NAME)

local CS = skynet.queue()



local CMD = {}


--登录 
function CMD.login(param)
    local username = param.username;
    local password = param.password;
    
    local uid="GIMXDpPzfJWFqL7XAAAA";
    local secret = "fdsaferghxxxf";
    --验证 token 并的到uid  目前没启动mysql 先假定写死
    local token = "fdsafGIMXDpPzfJWFqL7XAAAA";
    
    --调用login_third 替换下cmd 
    local result  = CMD.login_third ({username = username, token = token})
    result.cmd = all_game_command.CMD.common_user_login
    
    return result;
end





--第三方登录验证  
function CMD.login_third (param)
    local username = param.username;
    local token = param.token;
    
    local secret = "fdsaferghxxxf";
    
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local player = skynet.call(srv_token_login, "lua", "login_by_token", token,secret)

    local result;
    if player then 
        result = code_utils.package(all_game_command.CMD.common_user_login_third,code_error.OK,player)
    else
        result = code_utils.package(all_game_command.CMD.common_user_login_third,code_error.LOGIN_NAME_PW_ERROR,nil)
    end

    return result
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