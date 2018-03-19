#!/bin/bash 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 

# proto 源文件 
SOURCE_DIR="$DIR/../../../proto/"

# 发布的 目录文件
TARGET_DIR="$DIR/bin/sproto"


cd "$DIR/run/" 




./lua sprotodump.lua -spb $SOURCE_DIR/proto.c2s.sproto $SOURCE_DIR/proto.s2c.sproto -o $TARGET_DIR
