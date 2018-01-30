
--[[
srv_login_main.lua

login 的 入口管理service 

]]

local skynet = require "skynet"
local logger = log4.get_logger(SERVICE_NAME)

local center = require "center"


local CMD = {};

--[[
  开始
]]
function CMD.start_init()
    print(string.format("服务器 %s 启动完成！",SERVICE_NAME));
    local env = skynet.getenv("env")
    local config_server = require('config.' .. env .. ".config_server")
   
   
    --启动负载均衡的登录服务
    local port_login = config_server.game_100.server.port_login
    local body_size_limit_login = config_server.game_100.server.body_size_limit_login
    local srv_net_http_login = center.start_reboot_service("skynet", "srv_net_http", port_login,  body_size_limit_login,"agent")
    
    
    --http 短连接登录 验证用户名密码 或 token
    local srv_login_http = center.start_hotfix_service("skynet", "srv_login_http")
end


function CMD.info()
    -- TODO
end







skynet.start(function() 
    skynet.dispatch("lua", function(session, source, command, ...)
        local f = CMD[command]
        if not f then
            if session ~= 0 then
                skynet.ret(skynet.pack(nil))
            end
            return
        end
        if session == 0 then
            return f(...)
        end
        skynet.ret(skynet.pack(f(...)))
    end)

    CMD.start_init();
end)
