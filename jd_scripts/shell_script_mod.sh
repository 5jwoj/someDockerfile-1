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

## 删除运行目录中不在定时文件里的脚本
jsnames="$(cd /scripts && ls [jmz]*_*.js)"
for jsname in $jsnames; do
    if [ $(grep -c "$jsname" "$mergedListFile") -eq '0' ]; then
        if [[ "$jsname" == "jd_speed.js" || "$jsname" == "jd_crazy_joy_coin.js" ]]; then
            continue
        else
            rm -rf /scripts/$jsname
        fi
    fi
done

## 复制monk-coder仓库脚本到运行目录
js_dir="car&i-chenzhe&member&normal"
arr=${js_dir//&/ }
for item in $arr; do
    if [ -n "$(ls /monk-coder/$item/[mz]*_*.js)" ]; then
        cp -f /monk-coder/$item/[mz]*_*.js /scripts
    fi
done

## 删除不运行脚本
if [ -n "$(ls /scripts/[mz]*_*.js)" ]; then
    js_del="z_tcl_lining&z_health_community&z_health_energy&z_marketLottery&z_shake&z_super5g&z_xmf"
    arr=${js_del//&/ }
    for item in $arr; do
        rm -rf /scripts/$item.js
    done
fi

## 添加自定义脚本

## 京东试用
if [ $jd_try_ENABLE = "Y" ]; then
    wget -O /scripts/jd_try.js https://ghproxy.com/https://raw.githubusercontent.com/ZCY01/daily_scripts/main/jd/jd_try.js
fi
## 店铺签到
wget -O /scripts/jd_shop_sign.js https://ghproxy.com/https://raw.githubusercontent.com/Aaron-lv/JavaScript/master/Task/jd_shop_sign.js
## 红包雨
wget -O /scripts/jd_red_rain.js https://ghproxy.com/https://raw.githubusercontent.com/Aaron-lv/JavaScript/master/Task/jd_red_rain.js
wget -O /scripts/jd_live_redrain.js https://ghproxy.com/https://raw.githubusercontent.com/Aaron-lv/JavaScript/master/Task/jd_live_redrain.js

## 添加自定义脚本定时
echo "添加自定义脚本,脚本列表:"
jsnames="$(cd /scripts && ls [jmz]*_*.js)"
for jsname in $jsnames; do
    if [ $(grep -c "$jsname" "$mergedListFile") -eq '0' ]; then
        jsname_log="$(echo $jsname | cut -d \. -f1)"
        jscron="$(cat /scripts/$jsname | grep -oE "/?/?cron \".*\"" | cut -d\" -f2)"
        jsname_cn="$(cat /scripts/$jsname | grep -oE "/?/?const.*\$" | cut -d \' -f2 | cut -d \" -f2 | sed -n "1p")"
        test -n "$jscron" && test -n "$jsname_cn" && echo "# $jsname_cn" >> $mergedListFile
        test -n "$jscron" && echo "$jscron node /scripts/$jsname >> /scripts/logs/$jsname_log.log 2>&1" >> $mergedListFile
        test -n "$jscron" && echo $jsname
    fi
done

##红包雨定时
if [ -f "/jds/jd_scripts/red_rain_remote.sh" ]; then
    echo "# 红包雨" >> $mergedListFile
    echo "0,30 0-23/1 * * * sh /jds/jd_scripts/red_rain_remote.sh >> /dev/null 2>&1" >> $mergedListFile
fi
