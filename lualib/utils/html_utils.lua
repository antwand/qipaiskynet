
--[[
   html_utils .lua 
   html 工具类 


]]
local html_utils = {}



--[[
 解析网页的body 
@param
@return 
]]
html_utils.formatbody = function( body )
	local ret = {}

    local all =  string.split(body, "&")
    for k, v in pairs(all) do
        local one = string.split(v, "=")
        ret[one[1]] = one[2]
    end 

    return ret;
end






return html_utils;