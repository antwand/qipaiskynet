

local root = {}




--创建token
function root.token_create(uid,  password, secret)
    local timestamp = skynet_time()
    local s = string.format("%s:%s:%s", uid, timestamp, password)
    s = crypt.base64encode(crypt.desencode(secret, s))
    return s:gsub("[+/]", function (c)
        if c == '+' then
            return '-'
        else
            return '_'
        end
    end)
end

--解析token
function root.token_parse(token, secret)
    token = token:gsub("[-_]", function (c)
        if c == '-' then
            return '+'
        else
            return '/'
        end
    end)
    local s = crypt.desdecode(secret, crypt.base64decode(token))
    local uid, timestamp, password = s:match("([^:]+):([^:]+):(.+)")
    return uid, timestamp, password
end



--获取当前时间
function root.time_now_str()
    return os.date("%Y-%m-%d %H:%M:%S", skynet_time())
end





return root