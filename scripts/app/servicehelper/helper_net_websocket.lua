local skynet = require "skynet"
local httpd = require "http.httpd"
local websocket = require "websocket"
local sockethelper = require "http.sockethelper"

local root = {}

local handler = {}

local  m_body_size_limit , m_handle_type,m_srv;

--吧基础的数据丢进来
function root.init( body_size_limit,handle_type,srv)
    m_body_size_limit = body_size_limit
    m_handle_type = handle_type;
    m_srv = srv
end


function handler.on_open(ws)
    skynet.error(string.format("Client connected: %s", ws.addr))
    -- ws:send_text("Hello websocket !")
end

local host
local sprotoloader = require "sprotoloader"
local send_request
function handler.on_message(ws, msg)
    -- skynet.error("Received a message from client:\n"..msg)

    -- 测试 sproto
    -- if (msg == 'sproto') then
      host = sprotoloader.load(1):host "package"

      local type, msgType, msgTable, responseFunc = host:dispatch(msg);

	    -- send_request = host:attach(sprotoloader.load(2))
      --
      for k,v in pairs(msgTable) do
        print('客户端消息：', k,v)
      end
      local response = {
        result = 0,
        nickname = "long",
        headimg = "none",
        sex = 1,
        city = "beijing",
        country = "china",
      }
      local responseTable = responseFunc(response);

      ws:send_binary(responseTable);

      -- local pack = send_request('heartbeat', { name = 'long' })
      -- local package = string.pack(">s2", pack)
      -- print('long: ', pack);
      -- ws:send_binary(package)

      -- city 4 : string
      -- country 5 : string
      -- characters 6 : *integer
    -- else
      -- ws:send_text('reply: '..msg);
    -- end
end

function handler.on_error(ws, msg)
    skynet.error("Error. Client may be force closed.")
    -- do not need close.
    -- ws:close()
end

function handler.on_close(ws, code, reason)
    skynet.error(string.format("Client disconnected: %s", ws.addr))
    -- do not need close.
    -- ws:close
end

function root.handle_socket(fd, addr)

    local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(fd), tonumber(m_body_size_limit))

    if code then
        if string.match(url, "/ws/?") then
            local ws = websocket.new(fd, addr, header, handler)
            ws:start()
        end
    end
end

return root
