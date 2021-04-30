#!/bin/sh

if [[ -f /usr/bin/jd_bot && -z "$DISABLE_SPNODE" ]]; then
   CMD="spnode"
else
   CMD="node"
fi

if [ -z "$1" ]; then
   echo "红包雨活动id不存在，跳过执行..."
elif [ "$1" == "1" ]; then
   echo "红包雨活动id已内置，执行脚本..."
   $CMD /scripts/jd_red_rain.js |ts >> /scripts/logs/jd_red_rain.log 2>&1
else
   echo "红包雨活动id存在，替换并执行脚本..."
   sed -i "s/'$(date +%-H)': '.*$/'$(date +%-H)': '$1',/g" /scripts/jd_red_rain.js
   $CMD /scripts/jd_red_rain.js |ts >> /scripts/logs/jd_red_rain.log 2>&1
fi
