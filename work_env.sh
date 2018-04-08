#!/bin/bash

# 下载nmap
# https://hub.docker.com/r/uzyexe/nmap/
# docker pull uzyexe/nmap:7.12
# 使用: 
#    docker run --rm uzyexe/nmap [Scan Type(s)] [Options] {target specification}
#    docker run --rm uzyexe/nmap -p 80 example.com

# 查看指定镜像的版本
curl -s -S "https://registry.hub.docker.com/v2/repositories/uzyexe/nmap/tags/" | \
    sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
    grep '"name":' | \
    awk -F\" '{print $4;}' | \
    sed -e "s/^/${Repo}/"

### docker volumes
#### nginx
./my/nginx.conf:/etc/nginx/nginx.conf:ro
./my/mysite.conf:/etc/nginx/conf.d/mysite.conf

#### mysql
./my/my.cnf:/etc/mysql/my.cnf
./my/conf.d:/etc/mysql/conf.d
./my/mysql/datadir:/var/lib/mysql

#### redis
./my/conf/redis.conf:/usr/local/etc/redis/redis.conf
./my/redis/datadir:/data
