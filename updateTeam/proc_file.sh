#!/bin/sh

mergedListFile="/jds/updateTeam/merged_list_file.sh"

function initupdateTeam() {
    git config --global user.email "$email"
    git config --global user.name "$name"
    echo -e "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
    mkdir /updateTeam
    cd /updateTeam
    git init
    git remote add origin $updateTeam_URL
    git pull origin $updateTeam_BRANCH --rebase
}

if [ 0"$updateTeam_URL" = "0" ]; then
    echo "没有配置远程仓库地址，跳过初始化。"
else
    if [ ! -d "/updateTeam/" ]; then
        echo "未检查到updateTeam仓库，初始化下载..."
        initupdateTeam
    else
        cd /updateTeam
        echo "更新updateTeam仓库文件..."
        git reset --hard
        git pull origin $updateTeam_BRANCH --rebase
    fi
fi

##京喜工厂自动开团
if [ $jd_jxFactoryCreateTuan_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_jxFactoryCreateTuan.js
    echo "# 京喜工厂自动开团" >> $mergedListFile
    echo "0 * * * * node /scripts/jd_jxFactoryCreateTuan.js >> /scripts/logs/jd_jxFactoryCreateTuan.log 2>&1" >> $mergedListFile
fi

##更新抢京豆邀请码
if [ $jd_updateBeanHome_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_updateBeanHome.js
    echo "# 更新抢京豆邀请码" >> $mergedListFile
    echo "0 * * * * node /scripts/jd_updateBeanHome.js >> /scripts/logs/jd_updateBeanHome.log 2>&1" >> $mergedListFile
fi

##京东签到领现金
if [ $jd_updateCash_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_updateCash.js
    echo "# 京东签到领现金" >> $mergedListFile
    echo "0 * * * * node /scripts/jd_updateCash.js >> /scripts/logs/jd_updateCash.log 2>&1" >> $mergedListFile
fi

##更新东东小窝邀请码
if [ $jd_updateSmallHome_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_updateSmallHome.js
    echo "# 更新东东小窝邀请码" >> $mergedListFile
    echo "0 * * * * node /scripts/jd_updateSmallHome.js >> /scripts/logs/jd_updateSmallHome.log 2>&1" >> $mergedListFile
fi

##赚京豆小程序
if [ $jd_zzUpdate_ENABLE = "Y" ]; then
    sed -i "s/.\/shareCodes/\/shareCodes/g" /scripts/jd_zzUpdate.js
    echo "# 赚京豆小程序" >> $mergedListFile
    echo "0 * * * * node /scripts/jd_zzUpdate.js >> /scripts/logs/jd_zzUpdate.log 2>&1" >> $mergedListFile
fi

cp -rf /shareCodes /updateTeam/
echo "提交updateTeam仓库文件..."
cd /updateTeam
git add -A
git commit -m "更新JSON文件"
git push origin $updateTeam_BRANCH
