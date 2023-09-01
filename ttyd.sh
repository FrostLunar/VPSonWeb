#!/usr/bin/env bash

# 检测是否已运行
check_run() {
  [[ $(pgrep -lafx ttyd) ]] && echo "ttyd 正在运行中" && exit
}

# ssh argo 域名不设置，则不安装 ttyd 服务端
check_variable() {
  [ -z "${SSH_DOMAIN}" ] && exit
}

# 下载最新版本 ttyd
download_ttyd() {
  if [ ! -e ttyd ]; then
    URL=$(wget -qO- "https://api.github.com/repos/tsl0922/ttyd/releases/latest" | grep -o "https.*x86_64")
    URL=${URL:-https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64}
    wget -O ttyd ${URL}
    chmod +x ttyd
  fi
}

# 运行 ttyd 服务端
run() {
  [ -e nezha-agent ] && nohup ./ttyd -c ${WEB_USERNAME}:${WEB_PASSWORD} -p 2222 bash >/dev/null 2>&1 &
}

check_run
check_variable
download_ttyd
run
