local Player = import(".Player")

local PlayerList = {};
PlayerList.players = {};
PlayerList.meId = nil;


-- private
PlayerList.setPlayer = function(opts)
    local playerId = opts.id or opts.uid or opts.playerId;

    local player = Player:new(playerId, opts);
    PlayerList.players[playerId] = player;

    return player;
end

-- private
PlayerList.deletePlayer = function(playerId)
    local player = PlayerList.players[playerId];
    PlayerList.players[playerId] = nil;

    return player;
end
-- private
PlayerList.getPlayerByPlayerId = function(playerId)
    local player = PlayerList.players[playerId];

    return player;
end




return PlayerList