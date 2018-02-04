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
    local decks_num = opts.decks_num or 1 --几副牌
    
    local o = {
        roundid = roundid,
        rid = opts.rid,--房间id 
        masterId = opts.masterId, --庄家id 
        numberOfDecks = decks_num,--当前几份牌
        
        seat_uid_list = opts.seat_uid_list or {}, -- 坐下的玩家 
        watcher_uid_list = opts.watcher_uid_list or {},  -- 观察玩家
        
        --round = opts.round ,
        status = opts.status ,
        
        round_player_poker = opts.round_player_poker or {}, --当局每个玩家的牌 {uid:Round_Player_Poker,uid: }
        decks_poker = opts.decks_poker or  Decks:new(decks_num) , -- 桌面上的牌  能从外面传进来，也能全新创建，比如有些棋牌游戏，下一局，可能要用到上一局剩下的牌，而不是重新创建
        
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
        decks_num = self.decks_num,
        status = self.status,
        
        seat_uid_list = self.seat_uid_list, -- 坐下的玩家 
        watcher_uid_list = self.watcher_uid_list,  -- 观察玩家
        round_player_poker = self.round_player_poker or {},
        --decks_poker = self.decks_poker or {}
    }
    
    return o
end


--打印能显示的牌  比如如果是其他家取另一家的牌 只显示桌面上的牌 
function Round:toClosestring(uid)
    
    local round_player_poker = {};
    for k, v in pairs(self.round_player_poker) do
        if tostring(uid) == tostring(k) then 
            round_player_poker[k] = v:tostring()
        else
            round_player_poker[k] = v:toClosestring()
        end
    end
    
    local o =  {
        roundid = self.roundid,
        rid = self.rid,--房间id  
        masterId = self.masterId,
        decks_num = self.decks_num,
        status = self.status,
        
        seat_uid_list = self.seat_uid_list, -- 坐下的玩家 
        watcher_uid_list = self.watcher_uid_list,  -- 观察玩家
        round_player_poker = round_player_poker, -- {uid:Round_Player_Poker,uid:Round_Player_Poker}
        --decks_poker = self.decks_poker or {}
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
 给用户设置牌  
]]
function Round:set_round_player_poker(round_player_poker)
    self.round_player_poker = round_player_poker;
end
function Round:get_round_player_poker(round_player_poker)
    return self.round_player_poker;
end
function Round:get_open_round_player_poker(round_player_poker)
    local round_player_poker = self.round_player_poker;
    
    local newstr = {}
    for k,v in pairs(round_player_poker) do
        newstr[k] = v:tostring()
    end
    
    return newstr;
end



--[[
关闭这个牌局
]]
function Round:close()
    self:close_timeout()
end



return Round;
