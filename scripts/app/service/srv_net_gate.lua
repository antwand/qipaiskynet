--[[
srv_net_gate.lua 

WATCHDOG  每个用户一个 srv_net_gate_agent.lua 存储 

 服务器socket 网关  

]]

local skynet = require "skynet"



local gate --网关  只有一个 
local agent = {} --用户句柄 数组




--关闭网关  
local function close_agent(fd)
	local a = agent[fd]
	agent[fd] = nil
	if a then
		skynet.call(gate, "lua", "kick", fd)
		-- disconnect never return
		skynet.send(a, "lua", "disconnect")
	end
end





local SOCKET = {}
--下述代码，在gate在收到接入事件时被传递触发
-- 看门狗建立了agent并通过start指令将所有信息转交给它
function SOCKET.open(fd, addr)
	skynet.error("New client from : " .. addr)
	agent[fd] = skynet.newservice("srv_net_gate_agent")
	skynet.call(agent[fd], "lua", "start", { gate = gate, client = fd, watchdog = skynet.self() })
end

function SOCKET.close(fd)
	print("socket close",fd)
	close_agent(fd)
end

function SOCKET.error(fd, msg)
	print("socket error",fd, msg)
	close_agent(fd)
end

function SOCKET.warning(fd, size)
	-- size K bytes havn't send out in fd
	print("socket warning", fd, size)
end

--监听消息 
function SOCKET.data(fd, msg)
  
end









local CMD = {}

--[[
  启动gate服务 

 skynet.call(srv_net_gate, "lua", "start", {
    address = "127.0.0.1", -- 监听地址 127.0.0.1
    port = 8888,    -- 监听端口 8888
    maxclient = 1024,   -- 最多允许 1024 个外部连接同时建立
    nodelay = true,     -- 给外部连接设置  TCP_NODELAY 属性
  })

]]
function CMD.start(conf)
	skynet.call(gate, "lua", "open" , conf)
--  skynet.call(gate, "lua", "open", {
--    address = "127.0.0.1", -- 监听地址 127.0.0.1
--    port = 8888,    -- 监听端口 8888
--    maxclient = 1024,   -- 最多允许 1024 个外部连接同时建立
--    nodelay = true,     -- 给外部连接设置  TCP_NODELAY 属性
--  })
end

function CMD.close(fd)
	close_agent(fd)
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
	    if cmd == "socket" then
	    	local f = SOCKET[subcmd]
	    	f(...)
	    	-- socket api don't need return
	    else
	    	local f = assert(CMD[cmd])
	    	skynet.ret(skynet.pack(f(subcmd, ...)))
	    end
	end)

	gate = skynet.newservice("gate")
end)