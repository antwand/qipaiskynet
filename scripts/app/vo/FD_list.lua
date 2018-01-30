
local FD_list = {};
FD_list.fds = {};
--FD_list.meId = nil;


-- private
FD_list.setFd = function(fd,uid)
    FD_list.fds[fd] = uid;

    return uid;
end

-- private
FD_list.deleteFd = function(fd)
    local uid = FD_list.fds[fd];
    FD_list.fds[fd] = nil;

    return uid;
end
-- private
FD_list.getUidByFd = function(fd)
    local uid = FD_list.fds[fd];

    return uid;
end




return FD_list