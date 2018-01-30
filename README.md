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

<br>
<br>

- skynet
  1. cloud 下  
       Linux: make linux  
       Mac: make macosx 

  2.  <br>
       killall skynet  

  3.  <br>
       sh bin/start.sh

