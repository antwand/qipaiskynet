local skynet = require "skynet"
require "skynet.manager"
local logger = log4.get_logger(SERVICE_NAME)

--所有的mysql 连接池 
local MYSQL_DB_POOL = {}
--[[
mysql的连接的配置文件   比如 ：
  ["game"] = {  
      host="127.0.0.1",
      port=3306,
      database="test",
      user="test",
      password="123456",
      max_packet_size = 1024 * 1024
  },
]]
local MYSQL_CONFIG = {}





local CMD = {}



local function init_mysql_pool(name, config)
    local db_pool = {}
    MYSQL_CONFIG[name] = config
    for i = 1, 2 do 
        local db = skynet.newservice("srv_mysql_agent", cjson_encode(config), 8)
        db_pool[i] = db
    end
    MYSQL_DB_POOL[name] = db_pool
end

local function destory_mysql_pool(name)
    local db_pool = MYSQL_DB_POOL[name]
    MYSQL_DB_POOL[name] = {}
    for i = 1, #db_pool do
        local db = db_pool[i]
        skynet.kill(db)
    end
end



--[[
 查询
]]
function CMD.acquire(name)
    local config = MYSQL_CONFIG[name]
    if not config then
        logger.warn("not %s config mysql ", name)
        return 
    end

    local db_pool = MYSQL_DB_POOL[name]
    while true do
        if not db_pool or #db_pool < #config then
            skynet.sleep(100)
        else
            break
        end 
    end
    if #db_pool == 0 then
        logger.error("sup response.acquire db_pool is emtpy")
    end

    return db_pool
end






function CMD.init(name, cf)
    logger.info("init %s", name)
    if MYSQL_DB_POOL[name] then
        logger.warn("%s cf mysql already init", name)
        return
    end
    init_mysql_pool(name, cf)
end

function CMD.exit()
    for k, v in pairs(MYSQL_DB_POOL) do 
        destory_mysql_pool(k)
    end
    MYSQL_DB_POOL = {}
end





skynet.start(function ( ... )
    --[[
    skynet.name(name, address)：为一个地址命名。skynet.name(name, skynet.self()) 和 skynet.register(name) 功能等价。
            注意：这个名字一旦注册，是在 skynet 系统中通用的，你需要自己约定名字的管理的方法。
            以 . 开头的名字是在同一skynet节点下有效的，跨节点的 skynet 服务对别的节点下的 . 开头的名字不可见。不同的 skynet 节点可以定义相同的 . 开头的名字。
            以字母开头的名字在整个 skynet 网络中都有效，你可以通过这种全局名字把消息发到其它节点的。
            原则上，不鼓励滥用全局名字，它有一定的管理成本。管用的方法是在业务层交换服务的数字地址，让服务自行记住其它服务的地址来传播消息。

    ]]
    skynet.name(".mysql", skynet.self())

    skynet.dispatch("lua", function(session, _, command, ...)
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
end)
