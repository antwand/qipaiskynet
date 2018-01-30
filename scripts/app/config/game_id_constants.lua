
--[[
/**
 * 游戏ID定义
 * @author ""
 */
 ]]
local exports = {} 
 
exports.GAME_ALL = 0; --全部游戏（为了热更时 全部更新）


exports.BAIJIALE_DEBUG = 100; --百家乐（功能全开）
exports.BAIJIALE_AOMEN = 101; --澳门百家乐




exports.LANDLORDS = 201; -- 斗地主
exports.LANDLORDS_MIN_ID = 201; -- 斗地主最小ID
exports.LANDLORDS_MAX_ID = 201; -- 斗地主最大ID




exports.MAHJONG_DEBUG = 300; --测试麻将(功能全开)
exports.MAHJONG_SHAO_YANG = 301; -- 邵阳麻将
exports.MAHJONG_CHANG_SHA = 302; -- 长沙麻将
exports.MAHJONG_CHANG_DE = 303; -- 常德麻将
exports.MAHJONG_YONG_ZHOU = 304; -- 永州麻将
exports.MAHJONG_XIANG_TAN = 305; -- 湘潭麻将
exports.MAHJONG_MIN_ID = 301; -- 麻将最小ID
exports.MAHJONG_MAX_ID = 305; -- 麻将最大ID



--[[
 通过id 获取游戏名称  
]]
exports.getNameById = function(gameid)
    for k, v in pairs(exports) do
        if tostring(v) == tostring(gameid) then 
            local one = string.split(k, "_")
           
            return one[1];
        end
    end 
    
    return nil
end


return exports