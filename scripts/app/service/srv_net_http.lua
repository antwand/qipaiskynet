local skynet = require "skynet"
local socket = require "skynet.socket"
--local httpd = require "http.httpd"
--local sockethelper = require "http.sockethelper"
--local urllib = require "http.url"
local game_constants = require "app.config.game_constants";
local network =  require "app.servicehelper.network";
local helper_net_http = require "app.servicehelper.helper_net_http"
local logger = log4.get_logger(SERVICE_NAME)

--[[
NetHttp.lua
 
  NetHttp 的上层分装处理 
  主要有：
      start
      send
      close
      exit
      
      on_message
--]]
local m_port,  m_body_size_limit , m_srv_net_work = ...  --   端口   最大连接数      收到消息的中转处理 


local root = {}



local listen_id = nil;--监听id
local SOCKET_NUMBER = 0 --socket连接数目





--构造函数 
function root.start(port, body_size_limit,mode)
    m_port = port
   m_body_size_limit = body_size_limit
   helper_net_http.init( body_size_limit,game_constants.HANDLE_TYPE_HTTTP);
   
  
  if mode == "agent" then
     
     skynet.start(function()
          --负载均衡处理
          local agent = {}
          for i= 1, 20 do
            -- 启动 20 个代理服务用于处理 http 请求
            agent[i] = skynet.newservice("srv_net_http_agent",i)
            --agent[i] = skynet.newservice(SERVICE_NAME, "agent")  
          end
          
          local balance = 1
          -- 监听一个 web 端口
          local id = socket.listen("0.0.0.0", port)  
          socket.start(id , function(id, addr)  
                -- 当一个 http 请求到达的时候, 把 socket id 分发到事先准备好的代理中去处理。
                logger.debug(string.format("%s connected, pass it to agent :%08x", addr, agent[balance]))
                skynet.error(string.format("%s connected, pass it to agent :%08x", addr, agent[balance]))
                skynet.send(agent[balance], "lua", "on_socket", id, addr)
                balance = balance + 1
                if balance > #agent then
                  balance = 1
                end
           end)
      end)

     
      
  else
  
      skynet.start(function()
         local id = socket.listen("0.0.0.0", port)
          -- local id = socket.listen("127.0.0.1",port)
          listen_id = id
          skynet.error("Listen web port ", port)
          socket.start(id , function(fd, addr)
                root.on_socket( fd, addr)
          end)
      end)
      
  
  
  end
end



function root.exit()
    socket.close(listen_id)
end









------------------------------- private  -----------    
function root.on_socket( fd, addr)
    SOCKET_NUMBER = SOCKET_NUMBER + 1
    socket.start(fd)
    
  
    
    
    helper_net_http.on_socket( fd, addr);
    
    
    
    
    socket.close(fd)
    SOCKET_NUMBER = SOCKET_NUMBER - 1
end


root.start(m_port,  m_body_size_limit)

return root
