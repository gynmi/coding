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
./nginx.conf:/etc/nginx/nginx.conf:ro
./mysite.conf:/etc/nginx/conf.d/mysite.conf
