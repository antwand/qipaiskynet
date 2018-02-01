--[[
 round 列表 

]]
local Round = import(".Round")--require('Room');
  
local Round_list = {};
Round_list.rounds = {};


--每一个房间 
Round_list.initByRoom = function(roomid) 
    roomid = checkint(roomid)
    if Round_list.rounds[roomid] == nil then 
        Round_list.rounds[roomid] = {};
        
        
        return true
    end
    
    return false;
end




--// private 每一桌
Round_list.setRound = function(roomid,idx,opts) 
    roomid = checkint(roomid)
    if Round_list.rounds[roomid] == nil then 
        return nil
    end 

    if Round_list.rounds[roomid][idx] then 
        return false;
    end
    
    opts.rid = opts.rid;
    local round = Round:new(idx,opts)
    Round_list.rounds[roomid][idx] = round;

    return round;
end

----// private
--Round_list.deleteRound = function(roundid)
--
--    if (roundid) then
--        local round = Round_list.rounds[roundid];
--        Round_list.rounds[roundid] = nil;
--
--        return round;
--    end
--end

--// private
Round_list.getRoundByRoundId = function(roomid,index)
    roomid = checkint(roomid)
    local round = Round_list.rounds[roomid];
    if round then 
        if index == nil then index = #round end
        round = round[index]
    end

    return round;
end


Round_list.getRoundByRoomid= function(roomid)
    roomid = checkint(roomid)
    local round = Round_list.rounds[roomid];

    return round;
end





return Round_list;
