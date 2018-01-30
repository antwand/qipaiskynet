local skynet = require "skynet"
local netpack = require "skynet.netpack"
local socket = require "skynet.socket"
local sproto = require "sproto"
local sprotoloader = require "sprotoloader"

local WATCHDOG;



local REQUEST = {}
local client_fd

function REQUEST:get()
	print("get", self.what)
	local r = skynet.call("SIMPLEDB", "lua", "get", self.what)
	return { result = r }
end

function REQUEST:set()
	print("set", self.what, self.value)
	local r = skynet.call("SIMPLEDB", "lua", "set", self.what, self.value)
end

function REQUEST:handshake()
	return { msg = "Welcome to skynet, I will send heartbeat every 5 sec." }
end

function REQUEST:quit()
	skynet.call(WATCHDOG, "lua", "close", client_fd)
end



--收到消息处理 
-- REQUEST : 第一个返回值为 "REQUEST" 时，表示这是一个远程请求。如果请求包中没有 session 字段，表示该请求不需要回应。
--这时，第 2 和第 3 个返回值分别为消息类型名（即在 sproto 定义中提到的某个以 . 开头的类型名），以及消息内容（通常是一个 table ）；
--如果请求包中有 session 字段，那么还会有第 4 个返回值：一个用于生成回应包的函数。
local function request(name, args, response)
	local f = assert(REQUEST[name])
	local r = f(args)
	if response then
	
		-- 生成回应包(response是一个用于生成回应包的函数。)
    	-- 处理session对应问题
		return response(r)
	end
end
--发送消息处理 
local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end









local CMD = {}
local host
local send_request
function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	-- slot 1,2 set at main.lua
	host = sprotoloader.load(1):host "package"
	send_request = host:attach(sprotoloader.load(2))
	skynet.fork(function()
		while true do
			send_package(send_request "heartbeat")
			skynet.sleep(500)
		end
	end)

	client_fd = fd
  	--关键： agent还向gate发布了 forward指令
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	skynet.exit()
end






--register_protocol(class) 在当前服务类注册一类消息的处理机制。
skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
    unpack = function (msg, sz)
    	return host:dispatch(msg, sz)
    end,
    dispatch = function (_, _, type, ...)
    	if type == "REQUEST" then
	        local ok, result  = pcall(request, ...)
	        if ok then
	        	if result then
	        		send_package(result)
	          	end
	        else
	        	skynet.error(result)
	        end
	    else
	        assert(type == "RESPONSE")
	        error "This example doesn't support request client"
	    end
	end
}


skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
