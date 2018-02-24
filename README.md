# qipaiskynet
qipai   with  skynet


<br>
<br>
<br>


- blog 

  1. 服务端框架skynet: https://github.com/cloudwu/skynet/wiki 
  2. skynet学习资源：http://skynetclub.github.io/skynet/resource.html


<br>
<br>

- service 

  1.  log4g
  2.  mysql
  3.  websocket
  4.  http 
  6.  all suport agent,  load balancing
  5.  ...

<br>
<br>

- 3rd Third party library 

  1. cjson
  2. dpull的webclient (https://github.com/dpull/lua-webclient)
  3. lfs
  4. websocket

<br>
<br>

- git 

  1. submodule  
     git submodule add https://github.com/cloudwu/skynet.git

  2. update  
    git submodule init  
    git submodule update    <br>
    > submodule远程分支发生变更后，直接使用git submodule update是不会进行更新操作的  
    > git submodule foreach git checkout master  
    > git submodule foreach git pull  

  3. delete all git commit logs   
    http://blog.csdn.net/yc1022/article/details/56487680   
    ``` c++
    1.Checkout
        git checkout --orphan latest_branch
    2. Add all the files
        git add -A
    3. Commit the changes
        git commit -am "commit message"
    4. Delete the branch
        git branch -D master
    5.Rename the current branch to master
        git branch -m master
    6.Finally, force update your repository
        git push -f origin master
    ```
    
<br>
<br>

- skynet
  1. download  skynet  
       git submodule init  
       git submodule update  
       git submodule foreach git checkout master  
       git submodule foreach git pull 
  2. cloud 下  
       Linux: make linux  
       Mac: make macosx 

  3.  <br>
       killall skynet  

  4.  <br>
       sh bin/start.sh

  
<br>
<br>

- vo关系图
  1. vo  
       FD_list =》 fd  （就是连接的socket句柄）  
       PlayerList =》 Player （用户）  
       RoomList =》 Room       （房间）   
         
       Round_list =》   
       Round   （每一局）   
       Round_Player_Poker （每一局对应每个用户的牌） 

