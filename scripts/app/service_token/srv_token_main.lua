
--[[
srv_token_main.lua

token 的 入口管理service 

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
    
    local srv_token_login = center.start_hotfix_service("skynet", "srv_token_login")
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
