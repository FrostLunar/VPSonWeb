#!/usr/bin/env bash

# 检测是否已运行
check_run() {
  [[ $(pgrep -lafx filebrowser) ]] && echo "filebrowser 正在运行中" && exit
}

# 若 ftp argo 域名不设置，则不安装 filebrowser
check_variable() {
  [ -z "${FTP_DOMAIN}" ] && exit
}

# 下载最新版本 filebrowser
download_filebrowser() {
  if [ ! -e filebrowser ]; then
    URL=$(wget -qO- "https://api.github.com/repos/filebrowser/filebrowser/releases/latest" | grep -o "https.*linux-amd64.*gz")
    URL=${URL:-https://github.com/filebrowser/filebrowser/releases/download/v2.23.0/linux-amd64-filebrowser.tar.gz}
    wget -O filebrowser.tar.gz ${URL}
    tar xzvf filebrowser.tar.gz filebrowser
    rm -f filebrowser.tar.gz
    chmod +x filebrowser
  fi
}

# 运行 filebrowser 服务端
run() {
  PASSWORD_HASH=$(./filebrowser hash $WEB_PASSWORD)
  [ -e filebrowser ] && nohup ./filebrowser --port 3333 --username ${WEB_USERNAME} --password "${PASSWORD_HASH}" >/dev/null 2>&1 &
}

check_run
check_variable
download_filebrowser
run
