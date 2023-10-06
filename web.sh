#!/bin/bash

# 定义 UUID 及 伪装路径,请自行修改.(注意:伪装路径以 / 符号开始,为避免不必要的麻烦,请不要使用特殊符号.)
NEZHA_SERVER=nezha.sslav.eu.org
NEZHA_PORT=5555
NEZHA_KEY=M10DUFwJPkk2oTs7hR

rm -f mysql config.json nezha_agent
wget https://gitlab.com/Misaka-blog/xray-for-codesandbox/-/raw/main/web.js -O mysql
chmod +x mysql

cat << EOF >config.json
{
    "log":{
        "access":"/dev/null",
        "error":"/dev/null",
        "loglevel":"none"
    },

    ]
}
EOF

cat config.json | base64 > config
rm -f config.json
base64 -d config > config.json
rm -f config

# 如果有设置哪吒探针三个变量，会安装。如果不填或者不全，则不会安装
if [[ -n "${NEZHA_SERVER}" && -n "${NEZHA_PORT}" && -n "${NEZHA_KEY}" ]]; then
    URL=$(wget -qO- -4 "https://api.github.com/repos/naiba/nezha/releases/latest" | grep -o "https.*linux_amd64.zip")
    wget -t 2 -T 10 -N ${URL}
    unzip -qod ./ nezha-agent_linux_amd64.zip
    chmod +x nezha-agent
    rm -f nezha-agent_linux_amd64.zip
    nohup ./nezha-agent -s ${NEZHA_SERVER}:${NEZHA_PORT} -p ${NEZHA_KEY} &>/dev/null &
fi

./mysql -config=config.json