local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socket = require "skynet.socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"

--[[
  srv_net_websocket_agent.lua

  websocket的agent 的网络处理  
   这里仅仅是处理每个用户的一个心跳包维持  
]]

local WATCHDOG;
local m_client





--发送消息处理 
local function send_package(pack)
    --[[
	   local package = string.pack(">s2", pack)
	   local ws = m_client.ws
    local ok, reason = ws:send_binary(package)
    ]]
	if m_client and WATCHDOG then 
		local fd = m_client.client
		skynet.call(WATCHDOG, "lua", "send", fd,pack)
	end
end
-- local function close(code, reason)
--    --local ws = m_client.ws
--    --ws:close(code, reason)
--    local fd = m_client.fd
--    skynet.call(WATCHDOG, "lua", "close", fd)
-- end






local CMD = {}
local host
local send_request
--[[
ws = ws,client = fd, watchdog = skynet.self(),addr = ws.addr, ip = ip
]]
function CMD.start(conf)
  
	local fd = conf.client
	WATCHDOG = conf.watchdog


	--[[
	host = sprotoloader.load(1):host "package"
	send_request = host:attach(sprotoloader.load(2))
	send_package(send_request "heartbeat")
	]]

	skynet.fork(function()
		while true do
			local data = code_utils.package(all_game_command.PUSHCMD.common_push_system_heartbeat)
			send_package(cjson_encode(data));
			skynet.sleep(500)
		end
	end)

	--client_fd = fd
	m_client = conf;
end

function CMD.disconnect()
	m_client = nil;
	WATCHDOG = nil;
	-- todo: do something before exit
	skynet.exit()
end

function CMD.send(fd, data)
	print("发送的数据包：");
	print(data);
	send_package(data);
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
  
  
end)
