--[[
/**
 *  每一个牌局
 *
 * @type {Round}
 */
 ]]

local  Round = {};


--[[
/**
 * 构造函数
 * @param {Number} id
 * @param {Object|null} opts
 */
 ]]
function Round:new(roundid,opts)
    local o = {
        roundid = roundid,
        rid = opts.rid,--房间id 
        masterId = opts.masterId, --庄家id 
        
        seat_uid_list = opts.seat_uid_list or {}, -- 坐下的玩家 
        watcher_uid_list = opts.watcher_uid_list or {},  -- 观察玩家
        
        --round = opts.round ,
        status = opts.status ,
        
        round_playercard = opts.round_playercard or {},
        
        
        m_timeout = nil,--一个计时器  一个round一个计时器  
    }
    setmetatable(o, {__index = self})
    return o
end




--打印调试 
function Round:tostring()
   
    local o =  {
        roundid = self.roundid,
        rid = self.rid,--房间id  
        masterId = self.masterId,
        status = self.status,
        
        seat_uid_list = self.seat_uid_list, -- 坐下的玩家 
        watcher_uid_list = self.watcher_uid_list,  -- 观察玩家
        round_playercard = self.round_playercard or {},
    }
    
    return o
end


--打印能显示的牌  比如如果是其他家取另一家的牌 只显示桌面上的牌 
function Round:toClosestring(uid)
    
    local round_playercard = {};
    for k, v in pairs(self.round_playercard) do
        if tostring(uid) == tostring(k) then 
            round_playercard[k] = v:tostring()
        else
            round_playercard[k] = v:toClosestring()
        end
    
    end
    
    local o =  {
        roundid = self.roundid,
        rid = self.rid,--房间id  
        masterId = self.masterId,
        status = self.status,
        
        seat_uid_list = self.seat_uid_list, -- 坐下的玩家 
        watcher_uid_list = self.watcher_uid_list,  -- 观察玩家
        playerCards = round_playercard,
    }
    
    return o
end






--[[
  开启一个计时器 
  一个牌局里  始终保持只有一个倒计时  
]]
function Round:create_timeout(ti, func, ...)
    self:close_timeout();
    
    --永不超时 
    if ti == -1 then  
    elseif ti == 0 then
        if args then
            func(table.unpack(args))
        else
            func()
        end
    else
        self.m_timeout = create_timeout(ti, func, ...)
    end
end
function Round:close_timeout()
    if  self.m_timeout then 
        self.m_timeout:delete(); 
        self.m_timeout = nil;
    end
end



--[[
更改每一局的游戏状态 game_status.lua
]]
function Round:change_status(status)
    self.status = status;
end



--[[
关闭这个牌局
]]
function Round:close()
    self:close_timeout()
end



return Round;
