--[[
/**
    Round_PlayerCard.lua 

 *  每一个牌局 的每个玩家的 
 *
 * @type {Round_PlayerCard.lua}
 */
 ]]
 

local  root = {};


--[[
/**
 * 构造函数
 * @param {Number} id
 * @param {Object|null} opts
 */
 ]]
function root:new(uid,opts)
    local o = {
        uid = uid,
        leftCards = {}, -- 剩余的牌
        shownCards = {}, -- 已经出过的牌
        responseCards = {}, -- 已经响应过的牌(如吃、碰、杠过的牌等)
    }
    setmetatable(o, {__index = self})
    return o
end




--打印调试 
function root:tostring()
    local o =  {
        uid = self.uid,
        leftCards = self.leftCards,
        shownCards = self.shownCards,
        responseCards = self.responseCards,
    }
    
    return o
end


--打印能显示的牌  比如如果是其他家取另一家的牌 只显示桌面上的牌 
function root:toClosestring()
    local leftCards = {}
    
    for k, v in pairs(self.leftCards) do
        leftCards[#leftCards+1] = 0
    end
    
    local o =  {
        uid = self.uid,
        leftCards = leftCards,
        shownCards = self.shownCards,
        responseCards = self.responseCards,
    }
    
    return o
end



return root;
