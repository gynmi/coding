#!/bin/bash

PROJECT=$1

DEST_PROJECT=~/projects/${PROJECT}/.vscode/.env

cp ~/projects/bin/envs ${DEST_PROJECT}


getValueByKey() 
{
  value=$(grep "$1=" ${DEST_PROJECT} | awk -F "=" '{print $2}' )
  echo $value
}

replaceValue() 
{
  sed -i "s/\${$1}/$2/g" ${DEST_PROJECT}
}


host=$(getValueByKey 'host')
dev_server=$(getValueByKey 'dev_server')
ws_server=$(getValueByKey 'ws_server')
debug_server=$(getValueByKey 'debug_server')
mongo_server=$(getValueByKey 'mongo_server')
test_server=$(getValueByKey 'test_server')

WX_API_PORT=$(getValueByKey 'WX_API_PORT')
WX_CLIENT_PORT=$(getValueByKey 'WX_CLIENT_PORT')

replaceValue 'WX_API_PORT' ${WX_API_PORT}
replaceValue 'WX_CLIENT_PORT' ${WX_CLIENT_PORT}

WX_API=$(getValueByKey 'WX_API')
WX_CLIENT=$(getValueByKey 'WX_CLIENT')


# 替换
sed -i '1d' ${DEST_PROJECT}
sed -i "s/export //g" ${DEST_PROJECT}

replaceValue 'host' ${host}
replaceValue 'dev_server' ${dev_server}
replaceValue 'ws_server' ${ws_server}
replaceValue 'debug_server' ${debug_server}
replaceValue 'mongo_server' ${mongo_server}
replaceValue 'test_server' ${test_server}

replaceValue 'WX_API_PORT' ${WX_API_PORT}
replaceValue 'WX_CLIENT_PORT' ${WX_CLIENT_PORT}
replaceValue 'WX_API' ${WX_API}
replaceValue 'WX_CLIENT' ${WX_CLIENT}




echo ${host}
echo ${dev_server}
echo ${ws_server}
echo ${debug_server}
echo ${mongo_server}
echo ${test_server}

echo ${WX_API_PORT}
echo ${WX_CLIENT_PORT}
echo ${WX_API}
echo ${WX_CLIENT}
