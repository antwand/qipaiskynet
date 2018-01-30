 
local Language = require "i18n.zn"

local root = {}




--[[
   包装 通讯数据 
]]
function root.package(cmd,code,data)
	code = code or code_error.OK
    
    local result = 
    {
		cmd = cmd,
		code= code ,
		code_error = Language.label[code] , --错误码说明信息 
		data=data
    }
    
    
    return result;
end


return root