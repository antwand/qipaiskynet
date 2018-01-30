local cjson = require "cjson"
local skynet = require "skynet"




function cjson_encode(obj)
    return cjson.encode(obj)
end

function cjson_decode(json)
    return cjson.decode(json)
end



function is_robot(uid)
    return tonumber(uid) < 1000000
end



--获取当前时间戳
function skynet_time()
    return math.ceil(skynet.time())
end



--skynet中获取本地IP地址
function skynet_ip( ... )
	local str = (io.popen "ifconfig"):read "*a"
	local st = string.find(str,"inet") + 5
	local str2 = string.sub(str,st)
	local en = st + string.find(str2,' ')
	local ip = string.sub(str,st,en) -2

	return ip
end


--创建定时器 第一种方式  
function create_timeout(ti, func, ...)
    local active = true
    local args = {...}
    skynet.timeout(ti, function () 
        if active then
            active = false
            func(table.unpack(args))
        end
    end)
    local timer = {}

    timer.is_timeout = function ()
        return not active
    end
    timer.delete = function () 
        local is_active = active
        active = false
        return is_active
    end
    return timer
end