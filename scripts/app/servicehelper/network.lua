--[[
  network.lua

  连接服务器的中转触发类  

]]
local skynet = require "skynet"
local all_game_command = require "proto.all_game_command";






 ----- 命令处理类 
local CMD = {}



-- 监听http 
function CMD.command_http_handler(path,req,res)


	local result = nil;
	local body =req.body;
	--local bodytable = html_utils.formatbody(body)
	local bodytable = cjson_decode(body); 
	local cmd = bodytable.cmd
	local sn = bodytable.sn;

	print(body);
	print("command_http_handler : ",cmd);
	if cmd == all_game_command.CMD.common_user_login_third then -- 第三方登录 
		local srv_login_http = skynet.call("srv_center", "lua", "getOneServer", "srv_login_http")
		result = skynet.call(srv_login_http, "lua", "login_third", bodytable)
	elseif cmd == all_game_command.CMD.common_user_login then -- 登录 
		local srv_login_http = skynet.call("srv_center", "lua", "getOneServer", "srv_login_http")
		result = skynet.call(srv_login_http, "lua", "login", bodytable)
		
	
	
    elseif cmd == all_game_command.CMD.common_hall_createRoom then--创建房间 
        local srv_hall_room = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_room")
        result = skynet.call(srv_hall_room, "lua", "createRoom", bodytable)
    else
    	result = code_utils.package(nil,code_error.INVALID_PARAM,nil)
	end

	result.sn = sn;
	result.type = "RESPONSE"
	return cjson_encode(result); 
end






-- 监听 websocket 
function CMD.command_websocket_handler(msg,socket,fd)
	print(string.format("command_websocket_handler => msg : %s, fd :%s",tostring(msg),tostring(fd)));
	local msg = cjson_decode(msg)
	
	local result,closefd;
	local cmd = msg.cmd 


	if cmd == all_game_command.CMD.common_hall_login then 
        local srv_hall_login = skynet.call("srv_center", "lua", "getOneServer", "srv_hall_login")
        result = skynet.call(srv_hall_login, "lua", "login_by_uid_token", msg,socket,fd)
    elseif cmd == all_game_command.CMD.common_hall_login then 
        --result,closefd= skynet.call(srv_hall_login, "lua", "login_by_uid_token", msg,socket,fd)



    --游戏
    elseif cmd ==  all_game_command.CMD.common_game_login then
        local srv_game_login = skynet.call("srv_center", "lua", "getOneServer", "srv_game_login")
        result = skynet.call(srv_game_login, "lua", "login_by_uid_token", msg,socket,fd)
    elseif cmd == all_game_command.CMD.common_game_action then
        local srv_game_action = skynet.call("srv_center", "lua", "getOneServer", "srv_game_action")
        result = skynet.call(srv_game_action, "lua", "gameAction", msg,socket,fd)

    else
    	--没有命令 
    	result = code_utils.package(nil,code_error.INVALID_PARAM,nil)
	end
	
	
	--返回消息  否则自己内部处理，比如action 
	if result then 
    	result.sn = msg.sn;
    	result.type = "RESPONSE"
        return cjson_encode(result),closefd; 
    end
end







return CMD;