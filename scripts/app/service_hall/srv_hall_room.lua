--[[
    srv_hall_room.lua
    
     大厅的房间管理 
     创建 加入 销毁

]]
local skynet = require "skynet"
require "skynet.queue"
local logger = log4.get_logger(SERVICE_NAME)

local CS = skynet.queue()

local game_id_constants = require "app.config.game_id_constants"
local all_game_command = require "proto.all_game_command";
local game_scene = require "app.config.game_scene"

local Room_list = require "app.vo.Room_list"
local Player_list = require "app.vo.Player_list"


local ROOM_ID_INDEX = 0;--当前房间的index


local CMD = {}



--找出一个空房间 id来
local getCurrentRoomId = function()
    ROOM_ID_INDEX = ROOM_ID_INDEX +1;
    return ROOM_ID_INDEX
end


--找出一个空的房间邀请码
local getCurrentRoomCode = function()
     local rdm = math.random(100000,999999) --随机数
     
     
    --循环直到找到 空房间 
    while( Room_list.judge_roomcode_repeat(rdm) == true  ) do
        rdm = math.random(100000,999999) --随机数
    end
    
    
    return rdm
end


--根据游戏id返回一个动态的ip以及port给玩家 让玩家重新去连接
local getServerIPbyGameId = function(gameId )
    local env = skynet.getenv("env")
    local config_server = require('config.' .. env .. ".config_server")
    local gameservers = config_server.game_[gameId].server.game
    local rdm = math.random(1,#gameservers)

    local one = gameservers[rdm];
    local body_size_limit_hall = one.body_size_limit_hall
    local ip =  one.ip
    local port =  one.port
    
    return ip,port
end






function CMD.createRoom(param)
    local result;--返回数据

    local uid = param.uid;
    local gameId = param.gameId;
    local game_config = param.game_config;
    local sn = param.sn;
    
    
    --创建房间是短连接  我怎么保证用户的请求是否合法  去token验证一次即可 
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local player = skynet.call(srv_token_login, "lua", "get_player_by_uid", uid)
    if not player  then 
        result =  code_utils.package(all_game_command.CMD.common_hall_createRoom,code_error.LOGIN_IS_OFFLINE,nil)
        return result
    end
    
    --不在hall场景不能创建房间 属非法请求
    if player.serverScene ~= game_scene.HallScene then 
        result =  code_utils.package(all_game_command.CMD.common_hall_createRoom,code_error.HALL_OFFLINE,nil)
        return result
    end
    
    
    --判断用户是否在某个房间中 
    local rid = player.rid;
    if rid then 
         result = code_utils.package(all_game_command.CMD.common_hall_createRoom,code_error.SEAT_ALREAY_IN_ANOTHER_ROOM,nil)
         return;
    end
    
    
    --用户房卡是否足够 
    local gamename = game_id_constants.getNameById(gameId);
    local filename = string.format("game.%s.config.config_%s", gamename,gameId)
    local config = require (filename);
    if not config then 
        result = code_utils.package(all_game_command.CMD.common_hall_createRoom,code_error.INVALID_PARAM,nil)
        return;
    end
    
    
    --创建房间
    local rid = getCurrentRoomId();
    local room_code = getCurrentRoomCode();
    if rid then 
        --吧rid 标记进个人player里
        local success = skynet.call(srv_token_login, "lua", "setRid", rid)
        
        
        --创建round 
        local srv_game_action = skynet.call("srv_center", "lua", "getOneServer", "srv_game_action")
        local success = skynet.call(srv_game_action, "lua", "initByRoom", rid)
        if success == true then 
            
        else
            logger.error("create room is error ,rid: %s", rid)
        end
        
        

        --分配一个新的ip和port过去 
        local ip,port = getServerIPbyGameId(gameId);

        local pos = math.random(1,4)
        local data={
            ip = ip,
            port = port,
            rid = rid,
            room_code = room_code,
            masterId = uid,--庄家uid 
            game_config = game_config,
            seat_uid_list = {[pos] = player.uid}, --给自己一个随机位置
        }
        local room =  Room_list.setRoom(data);
        result = code_utils.package(all_game_command.CMD.common_hall_createRoom,code_error.OK,data)
        
    else
        -- todo 如果房间不够咋处理 
        result = code_utils.package(all_game_command.CMD.common_hall_createRoom,code_error.HALL_CREATE_ROOM_FULL,nil)
    end
    
    
    return result;
end






















--房间广播消息 
function CMD.broadcastRoom(rid, msg,filterUid)
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local room = Room_list.getRoomByRoomId(rid);

    logger.debug("roomid: %s broadcast",rid)
    local seat_uid_list = room.seat_uid_list -- 坐下的玩家 
    local watcher_uid_list = room.watcher_uid_list;-- 观察玩家
    
    
    local data = cjson_encode(msg)
    for k, v in pairs(seat_uid_list) do 
        if v and v ~= filterUid then 
            skynet.call(srv_token_login, "lua", "sendMsg", v,data)
        end
    end
    for k, v in pairs(watcher_uid_list) do 
        if v and v ~= filterUid then 
            skynet.call(srv_token_login, "lua", "sendMsg", v,data)
        end
    end
end


function CMD.broadcastByUids(uids, msg)
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
   
    local data = cjson_encode(msg)
    for k, v in pairs(uids) do 
        if v then 
            skynet.call(srv_token_login, "lua", "sendMsg", v,data)
        end
    end
end

function CMD.broadcastByUid(uid, msg)
    local srv_token_login = skynet.call("srv_center", "lua", "getOneServer", "srv_token_login")
    local data = cjson_encode(msg)
    skynet.call(srv_token_login, "lua", "sendMsg", uid,data)   
end






--// private
CMD.getRoomByRoomId = function(roomid)
    local room = Room_list.getRoomByRoomId(roomid);
    
    if room then 
        return room:tostring();
    end
    
    return nil;
end








function CMD.info()
    -- TODO
end



skynet.start(function() 
    skynet.dispatch("lua", function(session, _, command, ...)
        local f = CMD[command]
        if not f then
            if session ~= 0 then
                skynet.ret(skynet.pack(nil))
            end
            return
        end
        if session == 0 then
            return CS(f, ...)
        end
        skynet.ret(skynet.pack(CS(f, ...)))
    end)
end)