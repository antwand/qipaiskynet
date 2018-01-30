
local root =  {

    ["login"] = {  
        host="192.168.80.75",
        port=3306,
        database="test",
        user="test",
        password="123456",
        max_packet_size = 1024 * 1024
    },
    ["game"] = {  
        host="127.0.0.1",
        port=3306,
        database="test",
        user="test",
        password="123456",
        max_packet_size = 1024 * 1024
    },
    ["log"] = {           -- 日志数据库
        host="192.168.1.123",
        port=3306,
        database="test",
        user="test_log",
        password="123456",
        max_packet_size = 1024 * 1024        
    }
}



return root