local skynet = require "skynet"
require "skynet.manager"
local cluster = require "skynet.cluster"


local center = require "center"



skynet.start(function ()
    center.start_init();

    --logger4g 控制台 
    skynet.uniqueservice("srv_logger")
    skynet.newservice("debug_console", 8903)
    if not skynet.getenv "daemon" then
        local console = skynet.uniqueservice("console")
    end


--    -- 启动语音服务
--    local handle = skynet.uniqueservice("srv_voice")
--    skynet.name(".voice", handle)

    -- 获取配置环境
    local env = skynet.getenv("env")
    local config_server = require('config.' .. env .. ".config_server")
    local config_mysql = require('config.' .. env .. ".config_mysql")
    -- skynet.setenv("gate_etcd", config.etcd)



    --根据不同游戏加载不同的proto
    local srv_protoloader = center.start_hotfix_service("skynet", "srv_protoloader")
    --skynet.uniqueservice("srv_protoloader",nil) 


     --启动mysql 服务 
    --local srv_mysql = skynet.newservice("srv_mysql")
    local srv_mysql = center.start_reboot_service("skynet", "srv_mysql")
    cluster.register("srv_mysql", srv_mysql)
--    skynet.call(".mysql", "lua", "init", "login", config_mysql["login"]) 

    
    --启动gate socket 服务 
    --[[
    --local srv_net_gate = skynet.newservice("srv_net_gate")
    --cluster.register("srv_net_gate", srv_net_gate)
    local srv_net_gate = center.start_reboot_service("skynet", "srv_net_gate")
    --调用start方法 
    local gateserver = config_server.game_100.gateserver    
    skynet.call(srv_net_gate, "lua", "start",gateserver )
    ]]
    
    
    
    --启动token验证服务器 
    local srv_token_main = center.start_hotfix_service("skynetunique", "srv_token_main")
    
    --启动登录main
    --local srv_login_main = skynet.newservice("srv_login_main")
    --cluster.register("srv_login_main", srv_login_main)
    local srv_login_main = center.start_hotfix_service("skynetunique", "srv_login_main")
     
    -- --启动hall大厅main
    local srv_hall_main = center.start_hotfix_service("skynetunique", "srv_hall_main")
     
    
    --启动game游戏的main
    local srv_game_main = center.start_hotfix_service("skynetunique", "srv_game_main")
     
    
    

    skynet.exit()
end)