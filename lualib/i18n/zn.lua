
local code_error = require "constants.code_error"


local root = {}

root.label = {
    [code_error.OK] = "成功",
    [code_error.UNKNOWN] = "未知错误",
    [code_error.FORBIDDEND] = "禁止访问",
    [code_error.NOT_FOUND] = "请求未找到",
    [code_error.INTERNAL_SERVER_ERROR] = "服务器内部错误",
    [code_error.SERVICE_UNAVAILABLE] = "服务不可用",



    --登录
    [code_error.LOGIN_NAME_PW_ERROR]= "用户名或者密码错误",




    --游戏 code 
    [code_error.HALL_SEAT_ALREAY_IN_ANOTHER_ROOM] = "已经在其他房间了",
    [code_error.HALL_CREATE_ROOM_FULL] = "找不到空闲的房间",

    

--    [code_error.SEAT_NOT_ENTER_ROOM] = "还未进入房间",
--    [code_error.SEAT_ALREAY_FULL] = "房间已经满员",
--    [code_error.SEAT_NOT_ROOM_UID] = "不是房主",
--    [code_error.SEAT_NOT_WAIT_STATUS] = "房间不处于等待状态",
--    [code_error.SEAT_NOT_READY_STATUS] = "房间不处于准备状态",
--    [code_error.SEAT_DISSOLVE] = "房间已解散"
}


return root;




