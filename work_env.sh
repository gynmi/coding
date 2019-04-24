#!/bin/bash

# 下载nmap
# https://hub.docker.com/r/uzyexe/nmap/
# docker pull uzyexe/nmap:7.12
# 使用: 
#    docker run --rm uzyexe/nmap [Scan Type(s)] [Options] {target specification}
#    docker run --rm uzyexe/nmap -p 80 example.com

# access-token    828dca28f063f4dfc9c9f156c6b373bbb32e9fd8
# gid             56588e9d9a269368d855563d2a55b890

# 查看指定镜像的版本
curl -s -S "https://registry.hub.docker.com/v2/repositories/uzyexe/nmap/tags/" | \
    sed -e 's/,/,\n/g' -e 's/\[/\[\n/g' | \
    grep '"name":' | \
    awk -F\" '{print $4;}' | \
    sed -e "s/^/${Repo}/"

### docker volumes
#### nginx:1.13.11-alpine
./my/nginx.conf:/etc/nginx/nginx.conf:ro
./my/mysite.conf:/etc/nginx/conf.d/mysite.conf

#### mysql:5.7.21
./my/my.cnf:/etc/mysql/my.cnf
./my/conf.d:/etc/mysql/conf.d
./my/mysql/datadir:/var/lib/mysql

#### redis:4.0.9-alpine
./my/conf/redis.conf:/usr/local/etc/redis/redis.conf
./my/redis/datadir:/data

#### rabbitmq:3.7.4-management-alpine
./my/conf/rabbitmq.config:/etc/rabbitmq/rabbitmq.config
./my/rabbitmq/datadir:/var/lib/rabbitmq

# vscode 远程调试node (docker也可)
node_modules/.bin/babel-node app.js  --presets es2017,stage-3 --inspect=0.0.0.0:5858
{
  // 使用 IntelliSense 了解相关属性。 
  // 悬停以查看现有属性的描述。
  // 欲了解更多信息，请访问: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "name": "docker-web-api",
      "port": 5858,
      "address": "192.168.14.159",
      "localRoot": "${workspaceFolder}/",
      "remoteRoot": "/home/node/app/web_api/",
      "restart": true,
      // "sourceMaps": false,
      // "processId": "${command:PickProcess}",
    },
    {
      "type": "node",
      "request": "launch",
      "name": "web-api",
      "runtimeExecutable": "${workspaceFolder}/node_modules/.bin/babel-node",
      "program": "${workspaceFolder}/app.js",
      "env": {
        "NODE_ENV": "production"
      },
      "envFile": "${workspaceFolder}/.vscode/.env",
      "autoAttachChildProcesses": true
    }
  ]
}
