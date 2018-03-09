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

function handler.on_message(ws, msg)
    skynet.error("Received a message from client:\n"..msg)
    ws:send_text(msg)
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