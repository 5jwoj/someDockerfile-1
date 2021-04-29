#!/bin/sh

mergedListFile="/scripts/docker/merged_list_file.sh"

if [ $(grep -c "docker_entrypoint.sh" $mergedListFile) -eq '0' ]; then
    wget -O /scripts/docker/remote_task.sh https://ghproxy.com/https://raw.githubusercontent.com/Aaron-lv/someDockerfile/master/jd_scripts/docker_entrypoint.sh
    echo "# 远程定时任务" >> $mergedListFile
    echo "*/1 */1 * * * sh -x /scripts/docker/remote_task.sh >> /scripts/logs/remote_task.log 2>&1" >> $mergedListFile
    cat /scripts/docker/remote_task.sh > /scripts/docker/docker_entrypoint.sh
fi

## 克隆monk-coder仓库
if [ ! -d "/monk-coder/" ]; then
    echo "未检查到monk-coder仓库脚本，初始化下载相关脚本..."
    git clone -b dust https://github.com/Aaron-lv/sync /monk-coder
else
    echo "更新monk-coder脚本相关文件..."
    git -C /monk-coder reset --hard
    git -C /monk-coder pull origin dust --rebase
fi

## 删除运行目录的monk-coder仓库脚本
if [ -n "$(ls /scripts/[mz]*_*.js)" ]; then
    rm -rf /scripts/[mz]*_*.js
fi

## 复制monk-coder仓库脚本到运行目录
if [ -n "$(ls /monk-coder/car/*_*.js)" ]; then
    cp -f /monk-coder/car/*_*.js /scripts
fi
if [ -n "$(ls /monk-coder/i-chenzhe/*_*.js)" ]; then
    cp -f /monk-coder/i-chenzhe/*_*.js /scripts
fi
if [ -n "$(ls /monk-coder/member/*_*.js)" ]; then
    cp -f /monk-coder/member/*_*.js /scripts
fi
if [ -n "$(ls /monk-coder/normal/*_*.js)" ]; then
    cp -f /monk-coder/normal/*_*.js /scripts
fi

## 删除不运行脚本
if [ -n "$(ls /scripts/[mz]*_*.js)" ]; then
    js_del="z_tcl_lining&z_getFanslove&z_health_community&z_health_energy&z_marketLottery&z_shake&z_super5g&z_xmf"
    arr=${js_del//&/ }
    for item in $arr; do
        rm -rf /scripts/$item.js
    done
fi

## 添加monk-coder仓库脚本定时
echo "添加monk-coder仓库脚本,脚本列表:"
jsnames="$(cd /scripts && ls [mz]*_*.js)"
for jsname in $jsnames; do
    echo $jsname
    jsname_log="$(echo $jsname | cut -d \. -f1)"
    jscron="$(cat /scripts/$jsname | grep -oE "/?/?cron \".*\"" | cut -d\" -f2)"
    jsname_cn="$(cat /scripts/$jsname | grep -oE "/?/?const.*\$" | cut -d \' -f2 | cut -d \" -f2 | sed -n "1p")"
    test -n "$jscron" && test -n "$jsname_cn" && echo "# $jsname_cn" >> $mergedListFile
    test -n "$jscron" && echo "$jscron node /scripts/$jsname >> /scripts/logs/$jsname_log.log 2>&1" >> $mergedListFile
done

## 红包雨
wget -O /scripts/jd_red_rain.js https://ghproxy.com/https://raw.githubusercontent.com/Aaron-lv/JavaScript/master/Task/jd_red_rain.js
wget -O /scripts/jd_live_redrain.js https://ghproxy.com/https://raw.githubusercontent.com/Aaron-lv/JavaScript/master/Task/jd_live_redrain.js
if [ -f "/jds/jd_scripts/red_rain_remote.sh" ]; then
    echo "# 红包雨" >> $mergedListFile
    echo "0,30 0-23/1 * * * sh /jds/jd_scripts/red_rain_remote.sh >> /dev/null 2>&1" >> $mergedListFile
fi

## 京东试用
if [ $jd_try_ENABLE = "Y" ]; then
    wget -O /scripts/jd_try.js https://ghproxy.com/https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/jd_try.js
    echo "# 京东试用" >> $mergedListFile
    echo "30 10 * * * node /scripts/jd_try.js >> /scripts/logs/jd_try.log 2>&1" >> $mergedListFile
fi
