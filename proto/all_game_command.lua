


--[[
	所有命令集合   基于h5的json
]]
local exports={}





local allgame = {
	"common",
	"game_100"
}




---- 主动请求命令 
exports.CMD = {}

---- 推送命令
exports.PUSHCMD = {};




exports.init = function()
    exports.CMD = {}
    exports.PUSHCMD = {}
    for k, v in pairs(allgame) do
    	local filename = string.format("proto.%s.game_command", v)
    	local proto = require (filename);

    	local onecmd = proto.CMD;
    	local onepushcmd = proto.PUSHCMD;
    	--获取某一个 
    	for k1, v1 in pairs(onecmd) do
    		exports.CMD[k1] = v1;
    	end
    	for k2, v2 in pairs(onepushcmd) do
    		exports.PUSHCMD[k2] = k2;
    	end
    end
end





exports.init()



return exports


