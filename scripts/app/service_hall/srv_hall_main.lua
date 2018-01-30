
--[[
srv_hall_main.lua

hall 的 入口管理service 

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
   
    
    --启动大厅的http 连接
    local port_hall = config_server.game_100.server.port_hall
    local body_size_limit_hall = config_server.game_100.server.body_size_limit_hall
    local srv_net_http_login = center.start_reboot_service("skynet", "srv_net_http", port_hall,  body_size_limit_hall,"agent")
    
    
   
    --启动大厅 的gate  websocket服务
    local port_websocket = config_server.game_100.server.port_hall_websocket    
    local body_size_limit_websocket = config_server.game_100.server.body_size_limit_hall_websocket
    local srv_net_http_websocket = center.start_reboot_service("skynet", "srv_net_websocket", port_websocket,  body_size_limit_websocket)
    
    
    local srv_hall_login = center.start_hotfix_service("skynet", "srv_hall_login")
    
    --启动大厅服务
    local srv_hall_room = center.start_hotfix_service("skynet", "srv_hall_room")
    
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
