--[[
srv_net_websocket.lua 

 类似 WATCHDOG

 服务器websocket 网关  

]]

local skynet = require "skynet"
local websocket = require "websocket"
local socket = require "skynet.socket"
local helper_net_http = require "app.servicehelper.helper_net_http"
local game_constants = require "app.config.game_constants";


--local gate --网关  只有一个 
local SOCKET_TO_CLIENT = {} -- {agent = agent,ws = ws,client = fd, watchdog = skynet.self(),addr = ws.addr, ip = ip}





--关闭网关  
local function close_agent(fd)
	if not fd then return end
	local agent = SOCKET_TO_CLIENT[fd]
	SOCKET_TO_CLIENT[fd] = nil
	if agent then
		-- skynet.call(a, "lua", "kick", fd)
		-- disconnect never return
		local ws = agent.ws
		ws:close();
		skynet.send(agent.agent, "lua", "disconnect")
	end
end

local function send_agent(fd,data)
	local agent = SOCKET_TO_CLIENT[fd]
	if agent then
		local package = data--string.pack(">s2", data)
		local ws = agent.ws
		local ok, reason = ws:send_binary(package)
	end
end



--------------------------- private  start ------------------------------
local root = {};
function root.on_open(ws)
	print("srv_net_websocket.lua = > on_open (".. ws.fd ..")");
	skynet.error(string.format("Client connected: %s", ws.addr))
	local fd = ws.fd
	local ip = ws.addr:match("([^:]+):?(%d*)$")

	local agent = skynet.newservice("srv_net_websocket_agent")
	SOCKET_TO_CLIENT[fd] = {agent = agent,client = fd, watchdog = skynet.self(),addr = ws.addr, ip = ip,ws = ws}
	skynet.call(agent, "lua", "start", {client = fd, watchdog = skynet.self(),addr = ws.addr, ip = ip })
	
end
function root.on_message(ws, msg)
	print("srv_net_websocket.lua = > on_message (".. ws.fd ..")");
	local fd = ws.fd

	local agent = SOCKET_TO_CLIENT[fd]
	if agent then
	    --skynet.call(agent.agent, "lua", "on_message",msg)
	    local network =  require "app.servicehelper.network";
	    local result,closefd = network.command_websocket_handler(msg,skynet.self(),fd)
	    
	    if result then
	    	send_agent(fd,result);
	    end

	    if closefd == true then 
	    	close_agent(fd);
	    end
	end
    
      -- local data = {a ="sss",cmd = "login"};
      -- local cf = cjson_encode(data)
      -- root.send(fd,cf);
      
--      skynet.call(m_srv_net_work, "lua", "command_websocket_handler",msg)
end

function root.on_error(ws, msg)
		print("srv_net_websocket.lua = > on_error ("..tostring(ws.fd) ..")","msg:"..tostring(msg));
		local fd = ws.fd

		close_agent(fd)
 end

function root.on_close(ws, fd, code, reason)
    print("srv_net_websocket.lua = > on_close (".. tostring(fd) ..")");
    fd = fd or ws.fd
    
    close_agent(fd)
end 

--------------------------- private  end ------------------------------













--------------------------- cmd  start ------------------------------
local CMD = {};
--[[
  启动webscoket 
  http升级协议成websocket协议
 --]]
function CMD.start(req, res)
    print("srv_net_websocket.lua = > start (",req.fd,")");
    
    local fd = req.fd 
    local ws, err  = websocket.new(req.fd, req.addr, req.headers, root)
    if not ws then
        res.body = err
        return false
    end
    ws:start()
    return true
end

--[[
  发送数据
  --   local data = "{\"cmd\":\"login\",\"ret\":0,\"status\":\"success\",\"data\":{\"id\":\"GIMXDpPzfJWFqL7XAAAA\",\"name\":\"001\",\"avatar\":\"http://img6.bdstatic.com/img/image/smallpic/touxiang1227.jpeg\",\"gender\":1}}"
--   root.send(fd, data);


  local data = {a ="sss",cmd = "login"};
      local cf = cjson_encode(data)
      root.send(fd,cf);
 --]]
function CMD.send(fd, data)
	print("srv_net_websocket.lua = > send (",fd,")");
    
	send_agent(fd,data);
end
--end
--[[
  关闭 
 --]]
function CMD.close(fd)
    close_agent(fd)
end











 ------------------------------------- skynet start ----------------------------------------------------

local m_port,  m_body_size_limit = ...  --   端口   最大连接数
local listen_id = nil;--监听id
local SOCKET_NUMBER = 0 --socket连接数目

skynet.start(function()
  -- If you want to fork a work thread , you MUST do it in CMD.login
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
  
  
    --启动websocket
	helper_net_http.init( m_body_size_limit,game_constants.HANDLE_TYPE_WEBSOCKET,skynet.self());
	local id = socket.listen("0.0.0.0", m_port)
	-- local id = socket.listen("127.0.0.1",port)
	listen_id = id
	skynet.error("Listen web port ", m_port)
	socket.start(id , function(fd, addr)
		SOCKET_NUMBER = SOCKET_NUMBER + 1
		socket.start(fd)

		helper_net_http.on_socket( fd, addr);

		socket.close(fd)
		SOCKET_NUMBER = SOCKET_NUMBER - 1
	end)

	
end)
