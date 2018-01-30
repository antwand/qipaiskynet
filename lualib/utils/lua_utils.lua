local luautils = {}


--[[
  通过截取字符串所要长度 
  一个中文=2个英文=2个数字
]]
function luautils.unicode_formot(inputstr,len)
    inputstr=tostring(inputstr)
    if inputstr == nil or len == nil or len <= 0 then
        return ""
    end
    
    local out=""
    local lenInByte = #inputstr
    local width = 0
    local i = 1
    local x = 1
    
    
    while (i<=lenInByte) do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1
        if curByte>0 and curByte<=127 then
            byteCount = 1
            width = width + 1
        elseif curByte>=192 and curByte<223 then 
      byteCount = 2
      width = width + 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
            width = width + 2
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
            width = width + 2
        end
        if len < width then
        return out--..".."
    end
        local char = string.sub(inputstr, i, i+byteCount-1)
        i = i + byteCount
        out=out..char
        x = x + 1
    end
    return out
end


return luautils