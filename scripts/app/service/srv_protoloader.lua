local skynet = require "skynet"
local sprotoparser = require "sprotoparser" --加载skynet/lualib下的sproto解析器
local sprotoloader = require "sprotoloader" --sproto加器器





-- local m_proto_name = ...
--
--
-- --初始化
-- local init_proto = function(m_proto_name)
--     local filename = string.format("proto.all-proto")
--     if m_proto_name then
--         filename = string.format("proto.game_%s.proto", m_proto_name)
--     end
--     --local filename = string.format("proto.game_%s.sproto", gameid)
--     local proto = require (filename);
--
--     sprotoloader.save(proto.c2s, 1)
--     sprotoloader.save(proto.s2c, 2)
-- end

local m_proto_list = {
  'proto.c2s',
  'proto.s2c',
}


skynet.start(function()
    -- init_proto(m_proto_name);
    -- don't call skynet.exit() , because sproto.core may unload and the global slot become invalid
    loadSproto(m_proto_list);
end)




--local loader = {}   --保存函数
--local data = {}     --保存加载后的sproto协议在skynet sprotoparser里的序号，key值为文件名
--
--
--function loader.index(name)
--    return data[name]   --返回sproto协议在skynet sprotoloader里序号
--end
--
local function load(name)
   local filename = string.format("proto/%s.sproto", name)
   local f = assert(io.open(filename), "Can't open " .. name)
   local t = f:read "a"
   f:close()                       --以上为读取文件内容
   print('long: ', t);
   return sprotoparser.parse(t)    --调用skynet的sprotoparser解析sproto协议
end

--加载 sproto
function loadSproto(list)
   for i, name in ipairs(list) do
       local p = load(name)    --加载sproto协议
       print("load proto [" .. name .."] in slot "..i)
       sprotoloader.save(p, i) --保存解析后的sproto协议
   end
end








---- 初始化服务的info信息和函数
--local service = {}
---- 初始化服务，主要功能为：1：注册服务info 2：注册服务的命令函数 3：启动服务
--function service.init(mod)
--  local funcs = mod.command
--  if mod.info then
--    skynet.info_func(function() --
--      return mod.info
--    end)
--    -- 这里仅作调试用，当在调试模式下，输入 “info 服务ID” 就会打印上面返回的信息
--    -- 调试模式的启动方法为 nc 127.0.0.1 8000
--  end
--  skynet.start(function()
--    if mod.require then
--      local s = mod.require
--      for _, name in ipairs(s) do
--        service[name] = skynet.uniqueservice(name)  --启动服务，并将该服务器保存在service下
--      end
--    end
--    if mod.init then
--      mod.init()
--    end
--    skynet.dispatch("lua", function (_,_, cmd, ...) -- 修改lua协议的dispatch函数，对当前调用init的服务注册函数
--                            -- skynet.dispatch函数也是服务启动的结束标示
--      local f = funcs[cmd]  --获取命令函数
--      if f then
--        skynet.ret(skynet.pack(f(...))) --返回命令调用结果，所有通过ret的返回值都要用pack打包
--      else
--        log("Unknown command : [%s]", cmd)
--        skynet.response()(false)
--      end
--    end)
--  end)
--end
--
----[[skynet.ret 在当前协程(为处理请求方消息而产生的协程)中给请求方(消息来源)的消息做回应
--
--skynet.retpack 跟skynet.ret的区别是向请求方作回应时要用skynet.pack打包]]--
--
--return service
