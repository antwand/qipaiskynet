--[[
    房间列表 

]]
local Room = import(".Room")--require('Room');
  
local RoomList = {};
RoomList.rooms = {};

--// private
RoomList.setRoom = function(opts) 
    local roomid = opts.id or opts.rid or opts.rmid or opts.room_id or opts.roomid or opts.roomId;

  
    local room = Room:new(roomid,opts)
    RoomList.rooms[roomid] = room;

    return room;
end

--// private
RoomList.deleteRoom = function(roomid)

    if (roomid) then
        local room = RoomList.rooms[roomid];
        RoomList.rooms[roomid] = nil;

        return room;
    end
end

--// private
RoomList.getRoomByRoomId = function(roomid)
    local room = RoomList.rooms[roomid];

    return room;
end







--------------------------------------------------------------  util --------------------------------------

--[[
 判断当前这个邀请码是否重复
]]
RoomList.judge_roomcode_repeat = function(room_code)
    for key, value in pairs(RoomList.rooms) do  
        if value.room_code == room_code then 
            return true;
        end 
    end 

    return false;
end




return RoomList;
