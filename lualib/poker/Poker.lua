
local Suit = {
    Spade= 1,   -- 黑桃
    Heart= 2,   -- 红桃
    Club= 3,    -- 梅花(黑)
    Diamond= 4, -- 方块(红)
}
--十三张牌  1-13
local A2_10JQK = string.split('NAN,A,2,3,4,5,6,7,8,9,10,J,Q,K',',');


--[[
 * 扑克牌类，只用来表示牌的基本属性，不包含游戏逻辑，所有属性只读，
 * 因此全局只需要有 52 个实例（去掉大小王），不论有多少副牌
 * @class Poker
 * @constructor
 * @param {Number} point - 可能的值为 1 到 13
 * @param {Suit} suit
]]
local Poker = {}


function Poker:new(point, suit)
    local o = {
        point= point,
        suit =suit ,
        
        
        
        id = (suit - 1) * 13 + (point - 1),
        pointName = A2_10JQK[point],--点 A-k
        suitName = Suit[suit],--牌花
       
    }
    setmetatable(o, {__index = self})
    return o
end


--获取虚拟点数 1-10  其中JQK = 10点
function Poker:virtualPoint()
    if(self.point>10)then
        return 10;
    end
    return self.point
end
        
--调试显示 当前card的花数以及点数
function Poker:toString () 
    print(self.suitName + ' ' + self.pointName+ ' ' +self.id)
    return self.id
end












--///////////////////////////////////private///////////////////////////////////////////////////////////////////////

--// 存放 52 张扑克的实例
local pokers = {}

--// 初始化所有扑克牌
local createPokerss = function () 
    for s = 1 , 4 , 1 do  
        for p = 1 , 13, 1 do  
            --local poker = Poker:new(p, s);
            --服务器没必要实例化poker对象 ，直接存储id即可 
            local id = (s - 1) * 13 + (p - 1)
            pokers[id] = id;

            --cc.log("one poker :"+ id);
        end
    end
end;
createPokerss();




--//////////////////////////////exports/////////////////////////////////////////
--[[/**
 * 返回指定 id 的实例
 * @param {Number} id - 0 到 51
 ]]
function Poker.fromId (id)
    return pokers[id];
end

--[[
 *  通过id 获取卡牌的 花色和点
 * @param id
 * @returns {*[]}
]]
function Poker.getSuitPointById(id)
    local p = id %13 + 1;
    local s = (id - (p -1))/13 +1;
    return {s,p};
end


return Poker;
