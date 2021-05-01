#!/bin/sh

mergedListFile="/scripts/docker/merged_list_file.sh"
shareCodesUrl="https:\/\/ghproxy.com\/https:\/\/raw.githubusercontent.com\/Aaron-lv\/updateTeam\/master\/shareCodes\\"
shareCodeszz="$shareCodesUrl/jd_zz.json"
shareCodesCash="$shareCodesUrl/jd_updateCash.json"
shareCodesBeanHome="$shareCodesUrl/jd_updateBeanHome.json"
shareCodesFactoryTuanId="$shareCodesUrl/jd_updateFactoryTuanId.json"
shareCodesSmallHomeInviteCode="$shareCodesUrl/jd_updateSmallHomeInviteCode.json"

if [[ -f /usr/bin/jd_bot && -z "$DISABLE_SPNODE" ]]; then
   CMD="spnode"
else
   CMD="node"
fi

echo "处理jd_crazy_joy_coin任务..."
if [ ! $CRZAY_JOY_COIN_ENABLE ]; then
   echo "默认启用jd_crazy_joy_coin,杀掉jd_crazy_joy_coin任务，并重启"
   eval $(ps -ef | grep "jd_crazy_joy_coin" | grep -v "grep" | awk '{print "kill "$1}')
   echo '' >/scripts/logs/jd_crazy_joy_coin.log
   $CMD /scripts/jd_crazy_joy_coin.js |ts >>/scripts/logs/jd_crazy_joy_coin.log 2>&1 &
   echo "默认jd_crazy_joy_coin,重启完成"
else
   if [ $CRZAY_JOY_COIN_ENABLE = "Y" ]; then
      echo "配置启用jd_crazy_joy_coin,杀掉jd_crazy_joy_coin任务，并重启"
      eval $(ps -ef | grep "jd_crazy_joy_coin" | grep -v "grep" | awk '{print "kill "$1}')
      echo '' >/scripts/logs/jd_crazy_joy_coin.log
      $CMD /scripts/jd_crazy_joy_coin.js |ts >>/scripts/logs/jd_crazy_joy_coin.log 2>&1 &
      echo "配置jd_crazy_joy_coin,重启完成"
   else
      eval $(ps -ef | grep "jd_crazy_joy_coin" | grep -v "grep" | awk '{print "kill "$1}')
      echo "已配置不启用jd_crazy_joy_coin任务,不处理"
   fi
fi


## 修改闪购盲盒定时
sed -i "s/47 8 \* \* \* node \/scripts\/jd_sgmh.js/55 8,23 \* \* \* node \/scripts\/jd_sgmh.js/g" $mergedListFile
## 修改京东家庭号定时
sed -i "s/10 6,7 \* \* \* node \/scripts\/jd_family.js/30 6,15 \* \* \* node \/scripts\/jd_family.js/g" $mergedListFile
## 修改美丽颜究院定时
sed -i "s/41 7,12,19 \* \* \* node \/scripts\/jd_beauty.js/30 8,13,20 \* \* \* node \/scripts\/jd_beauty.js/g" $mergedListFile
## 修改口袋书店定时
sed -i "s/38 8,12,18 \* \* \* node \/scripts\/jd_bookshop.js/20 8,12,18 \* \* \* node \/scripts\/jd_bookshop.js/g" $mergedListFile
## 修改京东极速版红包定时
sed -i "s/45 0,23 \* \* \* node \/scripts\/jd_speed_redpocke.js/30 0,23 \* \* \* node \/scripts\/jd_speed_redpocke.js/g" $mergedListFile

## 清理日志
sed -i "s/find.*$/find \/scripts\/logs -name '\*.log' \| grep -v 'sharecodeCollection' \| xargs -i rm -rf {}/g" $mergedListFile

# 超级直播间红包雨
sed -i "s/^.*jd_live_redrain.*$/#&/g" $mergedListFile

## 赚京豆
sed -i "s/http:\/\/qr6pzoy01.hn-bkt.clouddn.com\/jd_zz.json/$shareCodeszz/g" /scripts/jd_syj.js
sed -i "s/https:\/\/raw.githubusercontent.com\/gitupdate\/updateTeam\/master\/shareCodes\/jd_zz.json/$shareCodeszz/g" /scripts/jd_syj.js
## 签到领现金
sed -i "s/\`eU9YL5XqGLxSmRSAkwxR@eU9YaO7jMvwh-W_VzyUX0Q@.*$/\`aUNmM6_nOP4j-W4@eU9Yau3kZ_4g-DiByHEQ0A@eU9YaOvnM_4k9WrcnnAT1Q@eU9Yar-3M_8v9WndniAQhA@f0JyJuW7bvQ@IhM0bu-0b_kv8W6E@eU9YKpnxOLhYtQSygTJQ@-oaWtXEHOrT_bNMMVso@eU9YG7XaD4lXsR2krgpG\`,/g" /scripts/jd_cash.js
sed -i "s/\`-4msulYas0O2JsRhE-2TA5XZmBQ@.*$/\`aUNmM6_nOP4j-W4@eU9Yau3kZ_4g-DiByHEQ0A@eU9YaOvnM_4k9WrcnnAT1Q@eU9Yar-3M_8v9WndniAQhA@f0JyJuW7bvQ@IhM0bu-0b_kv8W6E@eU9YKpnxOLhYtQSygTJQ@-oaWtXEHOrT_bNMMVso@eU9YG7XaD4lXsR2krgpG\`,/g" /scripts/jd_cash.js
sed -i "s/http:\/\/qr6pzoy01.hn-bkt.clouddn.com\/jd_cash.json/$shareCodesCash/g" /scripts/jd_cash.js
sed -i "s/https:\/\/cdn.jsdelivr.net\/gh\/gitupdate\/updateTeam@master\/shareCodes\/jd_updateCash.json/$shareCodesCash/g" /scripts/jd_cash.js
## 领京豆
sed -i "s/https:\/\/cdn.jsdelivr.net\/gh\/gitupdate\/updateTeam@master\/shareCodes\/jd_updateBeanHome.json/$shareCodesBeanHome/g" /scripts/jd_bean_home.js
## 京喜工厂
sed -i "s/http:\/\/qr6pzoy01.hn-bkt.clouddn.com\/factory.json/$shareCodesFactoryTuanId/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/raw.githubusercontent.com\/gitupdate\/updateTeam\/master\/shareCodes\/jd_updateFactoryTuanId.json/$shareCodesFactoryTuanId/g" /scripts/jd_dreamFactory.js
sed -i "s/https:\/\/cdn.jsdelivr.net\/gh\/gitupdate\/updateTeam@master\/shareCodes\/jd_updateFactoryTuanId.json/$shareCodesFactoryTuanId/g" /scripts/jd_dreamFactory.js
## 东东小窝
sed -i "s/https:\/\/cdn.jsdelivr.net\/gh\/gitupdate\/updateTeam@master\/shareCodes\/jd_updateSmallHomeInviteCode.json/$shareCodesSmallHomeInviteCode/g" /scripts/jd_small_home.js
sed -i "s/https:\/\/raw.githubusercontent.com\/LXK9301\/updateTeam\/master\/jd_updateSmallHomeInviteCode.json/$shareCodesSmallHomeInviteCode/g" /scripts/jd_small_home.js
## 美丽研究院
sed -i "s/Mozilla\/5.0 (iPhone; CPU iPhone OS 14_4 like Mac OS X) AppleWebKit\/605.1.15 (KHTML, like Gecko) Version\/14.0.3 Mobile\/15E148 Safari\/604.1/jdapp;iPhone;9.4.8;14.5;21e3e4be5bda669612c3ca00130f6e8e5a6e2653;network\/wifi;supportApplePay\/0;hasUPPay\/0;hasOCPay\/0;model\/iPhone12,3;addressid\/766018041;supportBestPay\/0;appBuild\/167629;jdSupportDarkMode\/0;Mozilla\/5.0 (iPhone; CPU iPhone OS 14_5 like Mac OS X) AppleWebKit\/605.1.15 (KHTML, like Gecko) Mobile\/15E148;supportJDSHWK\/1/g" /scripts/jd_beauty.js
## 口袋书店
sed -i "s/'28a699ac78d74aa3b31f7103597f8927@.*$/'6f46a1538969453d9a730ee299f2fc41@3ad242a50e9c4f2d9d2151aee38630b1',/g" /scripts/jd_bookshop.js
