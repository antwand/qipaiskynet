

--[[
 * 这个是玩家的所要操作的动作类型 
   和游戏的记录状态 game_status.lua 有差别 
 * @author ""
]]
local exports = {}



--百家乐 流程
exports.BAIJIALE = {
    READY = 1, -- 准备
    RESET_CARD =2,--切牌  洗牌
    BET = 3, -- 下注阶段
}



return exports;
