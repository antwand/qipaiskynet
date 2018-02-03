

--[[
 * 这个是玩家的所要操作的动作类型 
   和游戏的记录状态 game_status.lua 有差别 
 * @author ""
]]
local exports = {}



--百家乐 流程
exports.BAIJIALE = {
    READY = 0, -- 准备
    RESET_CARD =1,--切牌  洗牌
    BET = 2, -- 下注阶段
    
--    DEAL = 3, --// 发牌阶段
--    ENDED = 4, --// 已经结束(结算处理等)
--    CLOSED = 5, --// 已经关闭 房间结束
}



return exports;
