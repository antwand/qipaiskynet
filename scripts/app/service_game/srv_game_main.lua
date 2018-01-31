
--[[
srv_game_main.lua

game 的 入口管理service 

]]

local skynet = require "skynet"
local logger = log4.get_logger(SERVICE_NAME)

local center = require "center"


local m_game_id = ...  --当前的gameid



local CMD = {};

--[[
  开始
]]
function CMD.start_init()
    print(string.format("服务器 %s 启动完成！",SERVICE_NAME));
   
    local env = skynet.getenv("env")
    local config_server = require('config.' .. env .. ".config_server")
   
    
    
   
    --启动游戏 的gate  websocket服务
    local game = config_server["game_"..m_game_id].server.game[1]
    local port_game_websocket = game.port_game_websocket
    local body_size_limit_game_websocket = game.body_size_limit_game_websocket 
    
    local srv_net_http_websocket = center.start_reboot_service("skynet", "srv_net_websocket", port_game_websocket,  body_size_limit_game_websocket)
    
    --启动game 的login服务器
    local srv_game_login = center.start_hotfix_service("skynet", "srv_game_login")
    
    --启动game 的 action 服务器
    local srv_game_action = center.start_hotfix_service("skynet", "srv_game_action")
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
