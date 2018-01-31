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



    --根据不同游戏加载不同的proto 兼容小游戏目前用的是json 
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
    
    
    
    
    ----------------------------------------------------------------------------
    
       --[[ 
                            启动游戏服务器 
                             分为 token ，login ， hall ，game
                            每个下面会有一个_mian的脚本来负责管理以及启动
                            
             token负责所有用户的验证处理
             login负责用户登录的逻辑处理，会转交到token验证以及获取用户信息  可横向水平任意拓展
             hall 大厅，负责游戏创建房间  
                                                       （为了防止非法请求，进入hall的连接会先去token验证一次）
             game 负责各个子游戏的处理  目前只做了百家乐  可横向水平拓展  
                                                      （为了防止非法请求，进入hall的连接会先去token验证一次，并且是经过了hall进入的）
     --]]
     
    ----------------------------------------------------------------------------
    
    
    
    
    --启动token验证服务器  存储所有的用户信息 Round_list 
    local srv_token_main = center.start_hotfix_service("skynetunique", "srv_token_main")
    
    
    --启动登录 main  登录会去 srv_token_main 验证 
    --local srv_login_main = skynet.newservice("srv_login_main")
    --cluster.register("srv_login_main", srv_login_main)
    local srv_login_main = center.start_hotfix_service("skynetunique", "srv_login_main")
    
    
    -- --启动hall大厅main 存储所有房间信息 Room_list 
    local srv_hall_main = center.start_hotfix_service("skynetunique", "srv_hall_main")
    
     
    
    --启动game游戏的main 目前只做了一款 百家乐  存储所有的牌局 Round_list
    local srv_game_main = center.start_hotfix_service("skynetunique", "srv_game_main")
     
    
    

    skynet.exit()
end)