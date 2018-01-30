
服务端框架skynet: https://github.com/cloudwu/skynet/wiki 
skynet学习资源：http://skynetclub.github.io/skynet/resource.html

基于skynet的游戏框架
本框架解决问题
1. 服务器热更新
2. log4日志服务功能
3. web服务功能
4. 服务注册与发现功能
5. 基于http协议，消息序列化和反序列化基于json的rpc功能
6. mysql和redis代理功能
7. websocket



目录说明：
├── bin                     启动脚本
├── cservice                skynet cservice
├── doc                     文档
├── etc                     skynet进程启动配置文件
├── examples            
├── logs                    日志目录
├── luaclib                 lua c语言模块
├── lualib                  lua模块代码
├── lualib-src              lua c语言模块代码
├── run                     进程运行时存放文件目录，比如说进程pid
├── service                 skynet服务目录
├── service-src             skynet c语言服务代码
├── skynet                  skynet
└── test                    测试目录


集成库
1. cjson
2. dpull的webclient (https://github.com/dpull/lua-webclient)
3. lfs
4. websocket


编译前
ubuntu: sudo apt-get install libcurl4-gnutls-dev libreadline-dev autoconf
centos: sudo yum install libcurl-devel readline-devel  autoconf

编译
Linux: make linux
Mac: make macosx

启动命令：
./bin/start.sh

热更新命令：
./bin/start.sh -U
