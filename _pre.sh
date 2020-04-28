#!/usr/bin/env bash

_DIR=$(cd "$(dirname "$0")"; pwd)
cd $_DIR

if [ ! -d "node_modules" ]; then
yarn
fi

export PATH=$_DIR/node_modules/.bin:$PATH

if [ ! -f "$HOME/.fcli/config.yaml" ];then
echo -e "开始配置\n"
echo "账户编号 https://account.console.aliyun.com"
echo -e "访问私钥 https://usercenter.console.aliyun.com\n"
fun config
fi

cd src

CONFIG_COFFEE=config.coffee
if [ ! -f "$CONFIG_COFFEE" ];then
  echo "src/$CONFIG_COFFEE 使用默认的配置"
  ln -s $CONFIG_COFFEE.example $CONFIG_COFFEE
fi

if [ ! -d "node_modules" ]; then
fun install -d
fun nas sync
fi

