#!/bin/bash

cd openwrt

# 安装额外依赖软件包
# sudo -E apt-get -y install rename
#ln -s ../../diy ./package/openwrt-packages

# 更新feeds文件
#src-git liuran001_packages https://github.com/liuran001/openwrt-packages
#sed -i 's@#src-git helloworld@src-git helloworld@g' feeds.conf.default #启用helloworld
#sed -i '$a src-git helloworld https://github.com/fw876/helloworld' feeds.conf.default
#sed -i '$a src-git Boos4721 https://github.com/Boos4721/OpenWrt-Packages' feeds.conf.default
sed -i '$a src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
cat feeds.conf.default

# 更新并安装源
./scripts/feeds clean
./scripts/feeds update -a && ./scripts/feeds install -a

# 删除软件包
#rm -rf ./package/lean/UnblockNeteaseMusic
#rm -rf ./package/lean/UnblockNeteaseMusic-Go
#rm -rf .package/luci-app-clash

# 添加第三方软件包
#git clone https://github.com/gbaoye/openwrt-packages package/openwrt-packages
#git clone https://github.com/kenzok8/openwrt-packages package/openwrt-packages
#git clone https://github.com/destan19/OpenAppFilter package/OpenAppFilter
#git clone https://github.com/tty228/luci-app-serverchan package/luci-app-serverchan
#git clone https://github.com/garypang13/luci-theme-edge package/luci-theme-edge
#git clone https://github.com/kongfl888/luci-app-adguardhome package/luci-app-adguardhome
#git clone https://github.com/frainzy1477/luci-app-clash package/luci-app-clash
#git clone https://github.com/hubbylei/luci-app-clash package/luci-app-clash
#git clone https://github.com/110010110/luci-app-adguardhome package/luci-app-adguardhome
#git clone https://github.com/kenzok8/openwrt-packages/tree/master/luci-app-smartdns.git package/luci-app-smartdns
#git clone https://github.com/immortalwrt/luci-app-unblockneteasemusic.git package/luci-app-unblockneteasemusic
#git clone https://github.com/hubbylei/luci-app-clash package/luci-app-clash

# 下载自定义软件
#svn co https://github.com/kenzok8/openwrt-packages/tree/master/luci-app-clash ../package/luci-app-clash
#svn co https://github.com/kenzok8/openwrt-packages/tree/master/luci-app-openclash ../package/luci-app-openclash

# 替换更新插件
#rm -rf package/openwrt-packages/luci-app-passwall && svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-app-passwall package/openwrt-packages/luci-app-passwall
#rm -rf package/openwrt-packages/luci-app-ssr-plus && svn co https://github.com/fw876/helloworld package/openwrt-packages/helloworld
#rm -rf package/openwrt-packages/adguardhome && svn co https://github.com/Lienol/openwrt/tree/dev-19.07/package/diy/adguardhome package/openwrt-packages/adguardhome
#rm -rf package/openwrt-packages/luci-app-adguardhome && svn co https://github.com/kongfl888/luci-app-adguardhome package/openwrt-packages/luci-app-adguardhome
#rm -rf package/openwrt-packages/luci-app-clash && svn co https://github.com/hubbylei/luci-app-clash package/openwrt-packages/luci-app-clash

# 添加passwall依赖库
#git clone https://github.com/kenzok8/small package/small
#svn co https://github.com/Lienol/openwrt-package/tree/master/package package/small

# 替换更新haproxy默认版本
#rm -rf feeds/packages/net/haproxy && svn co https://github.com/Lienol/openwrt-packages/net/haproxy feeds/packages/net/haproxy

# 自定义定制选项
sed -i 's#192.168.1.1#10.1.1.1#g' package/base-files/files/bin/config_generate #定制默认IP
#sed -i 's@.*CYXluq4wUazHjmCDBCqXF*@#&@g' package/lean/default-settings/files/zzz-default-settings #取消系统默认密码
#sed -i 's#option commit_interval 24h#option commit_interval 10m#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计写入为10分钟
#sed -i 's#option database_directory /var/lib/nlbwmon#option database_directory /etc/config/nlbwmon_data#g' feeds/packages/net/nlbwmon/files/nlbwmon.config #修改流量统计数据存放默认位置
#sed -i 's@background-color: #e5effd@background-color: #f8fbfe@g' package/luci-theme-edge/htdocs/luci-static/edge/cascade.css #luci-theme-edge主题颜色微调
#sed -i 's#rgba(223, 56, 18, 0.04)#rgba(223, 56, 18, 0.02)#g' package/luci-theme-edge/htdocs/luci-static/edge/cascade.css #luci-theme-edge主题颜色微调
#sed -i 's/config internal themes/config internal themes\n    option atmaterial  \"\/luci-static\/atmaterial\"/g' feeds/luci/modules/luci-base/root/etc/config/luci #修改默认主题
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap #去除默认bootstrap主题

# 添加的 feeds 应用包优先于自带的 feed 里的 app
echo "重复的包检测：👇"
./scripts/feeds list  | awk '{if(a[$1]){print $1}else{a[$1]++}}'
echo "重复的包检测：👆"
./scripts/feeds list  | awk '{if(a[$1]){print $1}else{a[$1]++}}' | while read pkg_name;do

# 目录是 / 分隔，feeds/xxx/ 一样就不打印
find feeds/ -maxdepth 4 -type d -name $pkg_name | \
awk -F/ 'NR==1{a[$2]=$0};NR==2{if(!a[$2]){for(i in a){if(a[i]){printf "%s/ %s\n",$0,a[i]}}}}' | \
xargs -r -n2 echo  👉 rsync -av --delete
find feeds/ -maxdepth 4 -type d -name $pkg_name | \
 awk -F/ 'NR==1{a[$2]=$0};NR==2{if(!a[$2]){for(i in a){if(a[i]){printf "%s/ %s\n",$0,a[i]}}}}' | \
xargs -r -n2 rsync -av --delete
done

#创建自定义配置文件 - OpenWrt

rm -f ./.config*
touch ./.config

#
# ========================固件定制部分========================
# 

# 选择内核:
#cat >> .config <<EOF
#CONFIG_LINUX_5_4=y
#EOF

# 编译固件:
cat >> .config <<EOF
CONFIG_TARGET_ramips=y
CONFIG_TARGET_ramips_mt7621=y
CONFIG_TARGET_ramips_mt7621_DEVICE_d-team_newifi-d2=y
EOF

# 无线驱动(开源)
cat >> .config <<EOF
#CONFIG_PACKAGE_kmod-mt76=y
CONFIG_PACKAGE_luci-app-mtwifi=n
#CONFIG_PACKAGE_wireless-regdb=y
#CONFIG_PACKAGE_kmod-cfg80211=y
#CONFIG_PACKAGE_kmod-mac80211=y
#CONFIG_PACKAGE_MAC80211_DEBUGFS=y
#CONFIG_PACKAGE_MAC80211_MESH=y
#use opensource wifi driver
CONFIG_PACKAGE_kmod-mt7603=y
CONFIG_PACKAGE_kmod-mt7603e=n
CONFIG_PACKAGE_kmod-mt76x2=y
CONFIG_PACKAGE_kmod-mt76x2e=n
CONFIG_PACKAGE_hostapd-common=y
CONFIG_PACKAGE_wpad-openssl=y
CONFIG_PACKAGE_wpa-supplicant=y
EOF

# IPv6支持:
cat >> .config <<EOF
CONFIG_IPV6=y
CONFIG_KERNEL_IPV6=y
CONFIG_PACKAGE_ipv6helper=y
CONFIG_PACKAGE_dnsmasq_full_dhcpv6=y
CONFIG_PACKAGE_ip6tables=y
CONFIG_PACKAGE_iptables-mod-extra=y
EOF

# 多文件系统支持:
# cat >> .config <<EOF
# CONFIG_PACKAGE_kmod-fs-nfs=y
# CONFIG_PACKAGE_kmod-fs-nfs-common=y
# CONFIG_PACKAGE_kmod-fs-nfs-v3=y
# CONFIG_PACKAGE_kmod-fs-nfs-v4=y
# CONFIG_PACKAGE_kmod-fs-ntfs=y
# CONFIG_PACKAGE_kmod-fs-squashfs=y
# EOF

# USB3.0支持:
# cat >> .config <<EOF
# CONFIG_PACKAGE_kmod-usb-ohci=y
# CONFIG_PACKAGE_kmod-usb-ohci-pci=y
# CONFIG_PACKAGE_kmod-usb2=y
# CONFIG_PACKAGE_kmod-usb2-pci=y
# CONFIG_PACKAGE_kmod-usb3=y
# EOF

# 第三方插件选择:
cat >> .config <<EOF
#CONFIG_PACKAGE_luci-app-oaf=y #应用过滤
CONFIG_PACKAGE_luci-app-clash=y
#CONFIG_PACKAGE_luci-app-openclash=y #OpenClash
#CONFIG_PACKAGE_luci-app-serverchan=y #微信推送
#CONFIG_PACKAGE_luci-app-eqos=y #IP限速
CONFIG_PACKAGE_luci-app-adguardhome=y #ADguardhome
#CONFIG_PACKAGE_AdGuardHome=y
EOF

# ShadowsocksR插件:
#cat >> .config <<EOF
#CONFIG_PACKAGE_luci-app-ssr-plus=n
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Shadowsocks=n
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_ShadowsocksR_Socks=n
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Trojan=n
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_Kcptun=n
#CONFIG_PACKAGE_luci-app-ssr-plus_INCLUDE_V2ray=n
#EOF

# Passwall插件:
#cat >> .config <<EOF
CONFIG_PACKAGE_luci-app-passwall=y
#CONFIG_PACKAGE_https-dns-proxy=y
#CONFIG_PACKAGE_naiveproxy=y
#CONFIG_PACKAGE_kcptun-client=y
#CONFIG_PACKAGE_chinadns-ng=y
#CONFIG_PACKAGE_brook=y
#CONFIG_PACKAGE_trojan-go=y
#CONFIG_PACKAGE_shadowsocks-rust-sslocal=y
#EOF

# 常用LuCI插件:
cat >> .config <<EOF
#CONFIG_PACKAGE_luci-app-ttyd=y
#CONFIG_PACKAGE_luci-app-easymesh=n
#CONFIG_PACKAGE_luci-app-smartdns=y
#CONFIG_PACKAGE_luci-app-webadmin=n #Web管理页面设置
#CONFIG_PACKAGE_luci-app-ddns=y #DDNS服务
CONFIG_PACKAGE_luci-app-vlmcsd=n #KMS激活服务器
#CONFIG_PACKAGE_luci-app-filetransfer=y #系统-文件传输
CONFIG_PACKAGE_luci-app-autoreboot=y #定时重启
#CONFIG_PACKAGE_luci-app-upnp=y #通用即插即用UPnP(端口自动转发)
#CONFIG_PACKAGE_luci-app-accesscontrol=y #上网时间控制
CONFIG_PACKAGE_luci-app-wol=y #网络唤醒
#CONFIG_PACKAGE_luci-app-frpc=n #Frp内网穿透
#CONFIG_PACKAGE_luci-app-nlbwmon=n #宽带流量监控
#CONFIG_PACKAGE_luci-app-wrtbwmon=y
CONFIG_PACKAGE_automount=y
#CONFIG_PACKAGE_coreutils-base64=y
#CONFIG_PACKAGE_luci-app-commands=y
#CONFIG_PACKAGE_luci-app-jd-dailybonus=y
#CONFIG_PACKAGE_luci-app-nps=n
CONFIG_PACKAGE_luci-app-watchcat=y
#CONFIG_PACKAGE_luci-app-zerotier=y
#CONFIG_PACKAGE_luci-app-sfe=n #高通开源的 Shortcut FE 转发加速引擎
#CONFIG_PACKAGE_luci-app-flowoffload=y #开源 Linux Flow Offload 驱动
#CONFIG_PACKAGE_luci-app-haproxy-tcp is not set #Haproxy负载均衡
#CONFIG_PACKAGE_luci-app-diskman is not set #磁盘管理磁盘信息
#CONFIG_PACKAGE_luci-app-transmission is not set #TR离线下载
#CONFIG_PACKAGE_luci-app-qbittorrent is not set #QB离线下载
#CONFIG_PACKAGE_luci-app-amule is not set #电驴离线下载
#CONFIG_PACKAGE_luci-app-xlnetacc is not set #迅雷快鸟
#CONFIG_PACKAGE_luci-app-zerotier is not set #zerotier内网穿透
#CONFIG_PACKAGE_luci-app-hd-idle is not set #磁盘休眠
#CONFIG_PACKAGE_luci-app-wrtbwmon is not set #实时流量监测
#CONFIG_PACKAGE_luci-app-unblockmusic=y #解锁网易云灰色歌曲
CONFIG_PACKAGE_luci-app-unblockneteasemusic=y
#CONFIG_PACKAGE_luci-app-unblockmusic_INCLUDE_UnblockNeteaseMusic_NodeJS=y
#CONFIG_PACKAGE_luci-app-unblockmusic_INCLUDE_UnblockNeteaseMusic_Go=y
# CONFIG_PACKAGE_luci-app-airplay2 is not set #Apple AirPlay2音频接收服务器
# CONFIG_PACKAGE_luci-app-music-remote-center is not set #PCHiFi数字转盘遥控
# CONFIG_PACKAGE_luci-app-usb-printer is not set #USB打印机
#CONFIG_PACKAGE_luci-app-sqm=y #SQM智能队列管理
#
# VPN相关插件(禁用):
#
# CONFIG_PACKAGE_luci-app-v2ray-server is not set #V2ray服务器
# CONFIG_PACKAGE_luci-app-pptp-server is not set #PPTP VPN 服务器
# CONFIG_PACKAGE_luci-app-ipsec-vpnd is not set #ipsec VPN服务
# CONFIG_PACKAGE_luci-app-openvpn-server is not set #openvpn服务
# CONFIG_PACKAGE_luci-app-softethervpn is not set #SoftEtherVPN服务器
#
# 文件共享相关(禁用):
#
# CONFIG_PACKAGE_luci-app-minidlna is not set #miniDLNA服务
# CONFIG_PACKAGE_luci-app-vsftpd is not set #FTP 服务器
# CONFIG_PACKAGE_luci-app-samba is not set #网络共享
# CONFIG_PACKAGE_autosamba is not set #网络共享
# CONFIG_PACKAGE_samba36-server is not set #网络共享
EOF

# LuCI主题:
cat >> .config <<EOF
CONFIG_PACKAGE_luci-theme-atmaterial=y
#CONFIG_PACKAGE_luci-theme-bootstrap=y
#CONFIG_PACKAGE_luci-theme-argon_new=y
#CONFIG_PACKAGE_luci-theme-argon
#CONFIG_PACKAGE_luci-theme-netgear=y
#CONFIG_PACKAGE_luci-theme-edge=y
CONFIG_PACKAGE_luci-theme-material=y
EOF

# 常用软件包:
#cat >> .config <<EOF
#CONFIG_PACKAGE_curl=y
#CONFIG_PACKAGE_htop=y
#CONFIG_PACKAGE_nano=y
#CONFIG_PACKAGE_screen=y
#CONFIG_PACKAGE_tree=y
#CONFIG_PACKAGE_vim-fuller=y
#CONFIG_PACKAGE_wget=y
#EOF

# 其他软件包:
cat >> .config <<EOF
CONFIG_PACKAGE_lscpu=y
#CONFIG_HAS_FPU=y
EOF

# 取消编译VMware镜像以及镜像填充 (不要删除被缩进的注释符号):
#cat >> .config <<EOF
# CONFIG_TARGET_IMAGES_PAD is not set
# CONFIG_VMDK_IMAGES is not set
#EOF

# 
# ========================固件定制部分结束========================
# 


sed -i 's/^[ \t]*//g' ./.config

# 配置文件创建完成
