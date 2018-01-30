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
    --验证 token 并的到uid 
    
    
    local result;
    if true then 
         --验证用户名 密码 
        local data={
            uid = uid,
            username = username,
            nickname="张三",
            avatar="http://img6.bdstatic.com/img/image/smallpic/touxiang1227.jpeg",
            token=tool.token_create(uid, password, secret),
            diamonds = 100,
            gender=1
        }
        result = code_utils.package(all_game_command.common_user_login,code_error.OK,data)
    else
        result = code_utils.package(all_game_command.common_user_login,code_error.LOGIN_NAME_PW_ERROR,nil)
    end
    
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