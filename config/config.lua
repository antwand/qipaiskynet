cloudroot="./cloud/"
skynetroot = cloudroot .. "skynet/"
scriptsroot = "./scripts/"

--thread 启动多少个工作线程。通常不要将它配置超过你实际拥有的 CPU 核心数。
thread = 8 

--harbor 可以是 1-255 间的任意整数。一个 skynet 网络最多支持 255 个节点。每个节点有必须有一个唯一的编号。
harbor = 0

 -- main script 这是 bootstrap 最后一个环节将启动的 lua 服务，也就是你定制的 skynet 节点的主程序。默认为 main ，即启动 main.lua 这个脚本。这个 lua 服务的路径由下面的 luaservice 指定。
start = "main" 

--The service for bootstrap skynet 启动的第一个服务以及其启动参数。默认配置为 snlua bootstrap ，即启动一个名为 bootstrap 的 lua 服务。通常指的是 service/bootstrap.lua 这段代码。
bootstrap = "snlua bootstrap"  


--用哪一段 lua 代码加载 lua 服务。通常配置为 lualib/loader.lua ，
--再由这段代码解析服务名称，进一步加载 lua 代码。snlua 会将下面几个配置项取出，放在初始化好的 lua 虚拟机的全局变量中。具体可参考实现。
lualoader = skynetroot .. "lualib/loader.lua"  


-- 在设置完 package 中的路径后，加载 lua 服务代码前，loader 会尝试先运行一个 preload 制定的脚本，默认为空。
preload = "./global/preload.lua"   -- run preload.lua before every lua service run



--用 C 编写的服务模块的位置，通常指 cservice 下那些 .so 文件。如果你的系统的动态库不是以 .so 为后缀，需要做相应的修改。这个路径可以配置多项，以 ; 分割。
cpath = skynetroot.."cservice/?.so;".. "" ..cloudroot.."cservice/?.so" 


--将添加到 package.path 中的路径，供 require 调用
lua_path = skynetroot .. "lualib/?.lua;" ..
        -- skynetroot .. "lualib/compat10/?.lua;" ..
        cloudroot .. "lualib/?.lua;"..
        scriptsroot.."?.lua;" ..
        --            cloudroot .. "lualib/rpc/?.lua;".. 
        --            "./test/?.lua;" ..
        "./lualib/?.lua;" ..
        -- "./proto/?.lua;" ..
        "./?.lua" 
            
--将添加到 package.cpath 中的路径，供 require 调用。            
lua_cpath = skynetroot .. "luaclib/?.so;" .. cloudroot .."luaclib/?.so"






scriptsservice =scriptsroot.."app/service/?.lua;"..--"./server/?.lua;".. --"./service/?.lua;" ..
            scriptsroot.."app/service_token/?.lua;"..
            scriptsroot.."app/service_login/?.lua;"..
            scriptsroot.."app/service_hall/?.lua;"..
            scriptsroot.."app/service_game/?.lua;"..
            
            
            scriptsroot.."?.lua;"
            --            "./test/?.lua;" --.. 
            
luaservice = skynetroot.."service/?.lua;" .. scriptsservice

--用 snax 框架编写的服务的查找路径。
snax = scriptsservice



logpath = $LOG_PATH --日志写的文件 必须先建立一个这样的文件  这个已经在start.sh 启动即会自动创建文件夹
logmode = $DEBUG_MODE  --是否是skynet调试模式   
--etcdhost = $ETCDHOST
env = $ENV or "dev" --开发版本 
env_game_id = $ENV_GMAE_ID or "100"



--daemon 配置 daemon = "./skynet.pid" 可以以后台模式启动 skynet 。注意，同时请配置 logger 项输出 log 。
if $DAEMON then
    daemon = "./run/skynet-test.pid"
    logger = logpath .. "skynet-error.log"
end
