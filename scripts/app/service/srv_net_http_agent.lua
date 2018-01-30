local skynet = require "skynet"
local socket = require "skynet.socket"
local helper_net_http = require "app.servicehelper.helper_net_http"



local m_number = ...  



local CMD = {}
local SOCKET_NUMBER = 0 --socket连接数目



-- 处理socket 收到的消息     
function CMD.on_socket( fd, addr)
    print("srv_net_http_agent.lua = > start (".. fd.."),SOCKET_NUMBER:"..SOCKET_NUMBER,",m_number:"..m_number)

    SOCKET_NUMBER = SOCKET_NUMBER + 1
    -- 每当 accept 函数获得一个新的 socket id 后，并不会立即收到这个 socket 上的数据。这是因为，我们有时会希望把这个 socket 的操作权转让给别的服务去处理。
    -- 任何一个服务只有在调用 socket.start(id) 之后，才可以收到这个 socket 上的数据。
    socket.start(fd)
    
  
    
    
    helper_net_http.on_socket( fd, addr);
    
    
    
    
    socket.close(fd)
    SOCKET_NUMBER = SOCKET_NUMBER - 1
end







skynet.start(function() 
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
