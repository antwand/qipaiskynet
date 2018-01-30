
--[[

  code-constants.lua
      code码常量 

]]



local exports = {}


exports.SUCCESS = 0; -- 操作成功 
exports.FAILURE = 1; --操作失败 
exports.SERVER_MAINTENANCE = 2; -- 服务器维护中 
exports.SERVER_BUSY = 3; -- 服务器繁忙 
exports.LOGIN_TIMEOUT = 4; -- 登录超时或未登录 
exports.BAD_REQUEST = 5; -- 非法请求 
exports.REQUEST_TOO_FAST = 6; -- 请求太快 
exports.INVALID_PARAM = 7; -- 无效的参数 
exports.CMD_NOT_EXISTS = 8; -- 命令不存在 


--网页 code 
exports.OK = 200                               -- 成功
exports.UNKNOWN = 400                          -- 未知错误
exports.FORBIDDEND = 403                       -- 禁止访问
exports.NOT_FOUND = 404                       -- 请求未找到
exports.INTERNAL_SERVER_ERROR = 500            -- 服务器内部错误
exports.SERVICE_UNAVAILABLE = 503             -- 服务不可用
exports.SERVICE_UNAVAILABLE = 503             -- 服务不可用



--登录
exports.LOGIN_NAME_PW_ERROR = 1000             -- 用户名或者密码错误
exports.LOGIN_TOKEN_ERROR = 1001             -- token错误
exports.LOGIN_IS_OFFLINE = 1002              --用户已经掉线 



--游戏 code 
exports.HALL_OFFLINE = 5001              --用户不在hall场景
exports.HALL_SEAT_ALREAY_IN_ANOTHER_ROOM = 5002     -- 已经在其他房间了
exports.HALL_CREATE_ROOM_FULL = 5002     -- 房间满，找不到空闲的房间




exports.SEAT_NOT_ENTER_ROOM = 5002             -- 还未进入房间
exports.SEAT_ALREAY_FULL = 5003                -- 房间已经满员
exports.SEAT_NOT_ROOM_UID = 5004               -- 不是房主
exports.SEAT_NOT_WAIT_STATUS = 5005            -- 房间不处于等待状态
exports.SEAT_NOT_READY_STATUS = 5006           -- 房间不处于准备状态
exports.SEAT_DISSOLVE = 5007                   -- 房间已解散




-- 逆向通过code获取名称  
exports.name = function (code)
    for k, v in pairs(root) do 
        if v == code then
            return tostring(k)
        end
    end
    return "unknow code"
end



return exports