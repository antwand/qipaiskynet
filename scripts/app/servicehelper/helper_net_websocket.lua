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
    print('[Client->]', string.byte(msg, 1, #msg))
    print('msg length: ', #msg)
      host = sprotoloader.load(1):host "package"

      local type, msgType, msgTable, responseFunc = host:dispatch(msg);
	    send_request = host:attach(sprotoloader.load(2));

-- 接受客户端消息 返回结果 测试 OK
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
-- 接受客户端消息 返回结果 测试 OK

      -- 服务器推送消息 测试 OK
      local req = {
      name = 'long',
      total_cards = 123,
      nickname = '123',
      }
      local pack = send_request('refresh_card', req);
      print('pack', string.byte(pack, 1, #pack))
      print('package length: ', #pack)
      ws:send_binary(pack)
      -- 服务器推送消息 测试 OK
--

-- login

      -- local req = {
      --     platform = 'mocha',
      --     game = 'test',
      --     token = '123456',
      -- }
      -- local pack = send_request('login', req, 1);
      --
      -- local package = string.pack(">s2", pack)
      -- print('pack', string.byte(pack, 1, #pack))
      -- print('pack length: ', #pack)
      --
      -- print('package', string.byte(package, 1, #package))
      -- print('package length: ', #package)
      -- ws:send_binary(package)



    --   city 4 : string
    --   country 5 : string
    --   characters 6 : *integer
    -- else
    --   ws:send_text('reply: '..msg);
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
