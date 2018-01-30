local skynet = require "skynet"

local srv_center
local root = {}



function root.start_hotfix_service(type, service_name, ...)
    return skynet.call("srv_center", "lua","start_hotfix_service", type, service_name, ...)
end

function root.start_reboot_service(type, service_name, ...)
    return skynet.call("srv_center", "lua", "start_reboot_service", type, service_name, ...)
end


function root.start_init( ... )
	srv_center = skynet.uniqueservice("srv_center", "master")
end

-- skynet.init(function ()
-- 	srv_center = skynet.uniqueservice("srv_center", "master")
-- end)





return root