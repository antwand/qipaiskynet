--[[
 * 游戏配置
 * @author ""
]]

local exports ={}

exports.game_name = '百家乐'; --游戏名称
exports.game_id = 100; -- 游戏ID
exports.desk_player_num = 1; -- 几个人即可开桌
exports.max_player_num = 2; -- 最大玩家数
exports.max_watcher_num = 8; --最大观看者数(0表示不允许人观看)


exports.max_round = 8; -- 最大局数
exports.join_in_playing = 1; --1:可以中途加入，0:不可以
exports.show_card_animation_type = 1; --挤牌类型 1:3D翻动挤牌 2:滑动挤牌
exports.min_bet_num=1;
exports.max_bet_num=100;




exports.ai_tick_interval = 100; -- AI执行间隔(毫秒)

exports.reset_card_timeout = 0; -- 切牌超时(毫秒,-1表示不超时)
exports.bet_timeout = 0; -- 押注超时(毫秒,-1表示不超时)
exports.deal_card_timeout = 0; -- 庄家发牌超时(毫秒,-1表示不超时)
exports.next_round_timeout =0;--下一局开始的超时





----------------------- 服务器配置  ----------------------------------------------------

exports.need_room_card = 0; --一局需要几张房卡



return exports;