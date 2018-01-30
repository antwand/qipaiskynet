

-- local etcdfile = "/niuniu/gates/gate1"

local root = {
   -- etcdfile = etcdfile,
    game_100 = {
       -- name = etcdfile,
        server = {
            ip_login = "192.168.103.91",
            port_login = 8203,
            body_size_limit_login = 8192, --8k限制 
        
            
            --大厅短连接
            ip_hall = "192.168.103.91",
            port_hall = 8403,
            body_size_limit_hall = 8192, --8k限制 
            
            --大厅长连接 
            ip_hall_websocket = "192.168.103.91",
            port_hall_websocket = 8303,
            body_size_limit_hall_websocket = 65536,
            
            
            game = {
                {
                    ip_game_websocket = "192.168.103.91",
                    port_game_websocket = 8503,
                    body_size_limit_game_websocket = 65536,
                    -- maxclient = 1024,   -- 最多允许 1024 个外部连接同时建立
                    -- nodelay = true,     -- 给外部连接设置  TCP_NODELAY 属性
                },
                {
                    ip_game_websocket = "192.168.103.91",
                    port_game_websocket = 8603,
                    body_size_limit_game_websocket = 65536,
                    -- maxclient = 1024,   -- 最多允许 1024 个外部连接同时建立
                    -- nodelay = true,     -- 给外部连接设置  TCP_NODELAY 属性
                },
            }




        },
    }
}


return root