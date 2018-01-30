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
        
        seat_uid_list = opts.seat_uid_list, -- 坐下的玩家 
        watcher_uid_list = opts.watcher_uid_list,  -- 观察玩家
        
        --round = opts.round ,
        status = opts.status ,
        
        playerCards = {},
        
        
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
        playerCards = self.playerCards,
    }
    
    return o
end


--打印能显示的牌  比如如果是其他家取另一家的牌 只显示桌面上的牌 
function Round:toClosestring(uid)
    
    local playerCards = {};
    for k, v in pairs(self.playerCards) do
        if tostring(uid) == tostring(k) then 
            playerCards[k] = v:tostring()
        else
            playerCards[k] = v:toClosestring()
        end
    
    end
    
    local o =  {
        roundid = self.roundid,
        rid = self.rid,--房间id  
        masterId = self.masterId,
        status = self.status,
        
        seat_uid_list = self.seat_uid_list, -- 坐下的玩家 
        watcher_uid_list = self.watcher_uid_list,  -- 观察玩家
        playerCards = playerCards,
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
        func(table.unpack(args))
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



return Round;
