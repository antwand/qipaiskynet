--[[
 * 外部使用：
 *    local numberOfDecks = 1;//当前为几副牌
 *    self.decks = new Decks(numberOfDecks);
 *
 *    随机获取一张牌 ：
 *     self.decks:draw();
 *     获取桌上还没发的牌：
 *     self.decks:getCardIds();
 *    打乱重新使用整副牌：
 *     self.decks:reset();


 * @author antwand@sina.com
 * @type {{}}
]]

local Poker = require('.Poker');


local Decks ={}
--[[
 * 扑克管理类，用来管理一副或多副牌
 * @class Decks
 * @constructor
 * @param {number} numberOfDecks - 总共几副牌
]]
function Decks:new(numberOfDecks)
--    local pokerIds ={};
--    for s = 1 , numberOfDecks * 52 , 1 do 
--        pokerIds[#pokerIds +1] = 0;
--    end
    
    local o = {
        _numberOfDecks = numberOfDecks,-- 总共几副牌
        _pokerIds = {}, -- 还没发出去的牌
    }
    setmetatable(o, {__index = self})
    
    self:reset();
    return o
end

--[[
 * 重置所有牌
 * @method reset
]]
function Decks:reset () 
    --self._pokerIds = this._numberOfDecks * 52;
    local index = 1;
    local fromId = Poker.fromId;
    for i = 1 , self._numberOfDecks, 1 do  --for (var i = 0; i < this._numberOfDecks; ++i) {
        for pokerId = 0 , 51 , 1 do--for (var pokerId = 0; pokerId < 52; ++pokerId) {
            self._pokerIds[index] = fromId(pokerId);--赋值
            index = index+1;
        end
    end
end

--[[
 * 随机抽一张牌，如果已经没牌了，将返回 null
 * @method draw
 * @return {Card}
]]
function Decks:draw () 
    local pokerIds = self._pokerIds;
    local len = #pokerIds;
    if (len == 0) then
        return nil;
    end

    local random = math.random();
    local index = checkint(random * len) or 0;
    local result = pokerIds[index];

    -- 保持数组紧凑
    local last = pokerIds[len];
    pokerIds[index] = last;
    --#pokerIds = len - 1;
    table.remove(pokerIds, len)

    return result;
end




return Decks;
