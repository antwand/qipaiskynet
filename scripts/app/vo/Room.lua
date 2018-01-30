local skynet = require "skynet"
local logger = log4.get_logger("room")

local game_status = require "app.config.game_status" 


local room = {}

function room:new(rid,opt)
  
    local o = {
        rid = rid,                          -- 房间id
        room_code = opt.room_code,           --房间邀请码
        masterId = opt.masterId,            -- 房主uid
        createTime = opt.createTime,        -- 创建时间
        status = game_status.ROOM.WAIT,          -- 房间状态
        game_config = opt.game_config,      -- 游戏配置信息
        
        
        -- TODO：init 房间信息
        seat_uid_list = {},                 -- 坐下的玩家 
        watcher_uid_list = {},              -- 观察玩家
        
    }

    setmetatable(o, {__index = self})
    return o
end




--打印调试 
function room:tostring()
    local o =  {
        masterId = self.masterId,
        rid = self.rid,
        room_code = self.room_code,
        createtime = self.createtime,
        seat_uid_list = self.seat_uid_list,
        watcher_uid_list = self.watcher_uid_list,
    }
    --[[
    for _, v in ipairs(self.seat_uid_list) do 
        table.insert(o.seat_uid_list, v:totable())
    end
    ]]
    return o
end



--重新赋值房间  
function room:reload(opt)
    self.masterId = opt.masterId;            -- 房主uid
    self.rid = opt.rid;                      -- 房间id
    self.createtime = opt.createtime;
    self.status = game_status.WAIT;          -- 房间状态
    self.game_config = opt.game_config;      -- 游戏配置信息
    
    
    -- TODO：init 房间信息
    self.seat_uid_list =opt.seat_uid_list or  {};                 -- 坐下的玩家 
    self.watcher_uid_list =opt.watcher_uid_list or {};            -- 观察玩家
end







--function room:push_message(uid, name, msg)
--    logger.debug("uid %s push_message %s", uid, name)
--    local session = self.uid_to_session[uid]
--    if not session then
--        logger.debug("push_message %s %s not session uid_to_session %s", uid, name, tostring(self.uid_to_session))
--        return
--    end
--    local agent = session.agent
--    local fd = session.fd
--    -- srv_room => srv_web_agent => wsapp CMD.emit => app proto s2c
--    skynet.send(session.agent, "lua", "emit", fd, "s2c", name, msg)
--end
--
--function room:broadcast(name, msg)
--    logger.debug("%s broadcast", name)
--    for uid, _ in pairs(self.uid_to_session) do 
--        self:push_message(uid, name, msg)
--    end
--end
--
--function room:get_player(uid)
--    return table.key_find(self.player_list, "uid", uid)
--end
--房间语言
--function room:room_voice(session, msg)
--    self:broadcast("on_room_voice", msg)
--    return {code = code.OK}
--end
--
--
-- app proto c2s => srv_room c2s => room object method
--function room:room_enter(session, msg)
--    local uid = session.uid
--    if not self.uid_to_session[uid] then
--        self.uid_to_session[uid] = session
--        local p = self:get_player(uid)
--        if not p then
--            local p = gate_player:new({uid = uid})
--            table.insert(self.player_list, p)
--            self:broadcast("on_room_enter", { player = p:totable()})
--        else
--            p.online = true
--        end
--    end
--    local player_list = {}
--    for _, v in ipairs(self.player_list) do 
--        table.insert(player_list, v:totable())
--    end
--    return {code = code.OK, player_list = player_list}
--end
--
--function room:room_leave(session, msg)
--    self:broadcast("on_room_leave", {uid = session.uid})
--    self.uid_to_session[session.uid] = nil
--    local p = self:get_player(session.uid)
--    if p then
--        table.delete(self.player_list, p)
--        skynet.send(".room", "lua", "leave", session.uid)
--    end
--    return {code = code.OK}
--end
--
--function room:room_offline(session)
--    local uid = session.uid
--    self.uid_to_session[uid] = nil
--    local p = self:get_player(uid)
--    if p then
--        p.online = false
--        self:broadcast("on_room_offline", {uid = uid})
--    end
--    return {code = code.OK}
--end


----关闭房间
--function room:close()
--    skynet.send(".srv_hall_room", "lua", "close", self.rid)
--end

return room