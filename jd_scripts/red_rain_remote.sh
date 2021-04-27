#!/bin/sh

if [[ -f /usr/bin/jd_bot && -z "$DISABLE_SPNODE" ]]; then
   CMD="spnode"
else
   CMD="node"
fi

if [ -f "/scripts/jd_red_rain.js" ]; then
    red_url="https://ghproxy.com/https://raw.githubusercontent.com/Aaron-lv/JavaScript/master/jd_red_rain.json"
    lzz_red_url="https://ghproxy.com/https://raw.githubusercontent.com/nianyuguai/longzhuzhu/main/qx/jd-live-rain.json"
    red_url_tmp="$(curl -s $red_url)"
    red_url_control="$(echo $red_url_tmp | cut -d \, -f1)"
    red_url_id="$(echo $red_url_tmp | cut -d \, -f2)"
    red_rain_control="$(echo $red_url_control | cut -d \& -f1)"
    live_redrain_control="$(echo $red_url_control | cut -d \& -f2)"

    if [ "$(date +%-M)" != "30" ]; then
        echo "运行整点红包雨，开始获取红包雨活动id..."
        if [ "$red_rain_control" == "0" ]; then
            red_id="$red_url_id"
        else
            lzz_red_url_id="$(curl -s $lzz_red_url)"
            red_id="$red_url_id;$lzz_red_url_id"
        fi
        arr=${red_id//;/ }
        for item in $arr; do
            sh -x /scripts/docker/red_rain.sh $item
        done
    fi

    if [[ "$(date +%-H)" -ge "20" && "$(date +%-H)" -le "23" ]]; then
        if [ "$(date +%-M)" == "30" ]; then
            if [ "$live_redrain_control" == "0" ]; then
                echo "配置不运行超级直播间红包雨，跳过执行..."
            else
                echo "配置运行超级直播间红包雨，开始执行..."
                lzz_half_url="https://ghproxy.com/https://raw.githubusercontent.com/nianyuguai/longzhuzhu/main/qx/jd-half-rain.json"
                lzz_half_id="$(curl -s $lzz_half_url)"
                arr=${lzz_half_id//;/ }
                for item in $arr; do
                    sed -i "s/id = '.*$/id = '$item';/g" /scripts/jd_live_redrain.js
                    $CMD /scripts/jd_live_redrain.js |ts >> /scripts/logs/jd_live_redrain.log 2>&1
                done
            fi
        fi
    fi

fi
