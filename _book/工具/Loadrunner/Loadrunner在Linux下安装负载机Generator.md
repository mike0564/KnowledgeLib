# Loadrunner在Linux下安装负载机Generator

本文主要介绍怎么在Linux下安装LoadRunner负载机loadrunner-11-load-generator.iso

## 挂载load-generator镜像

第一种方式：采用citrix或VMware虚拟化，客户端操作装入iso盘 
– 创建挂载区 
`mkdir /mnt/cdrom `
– 挂载镜像 
`mount /dev/cdrom /mnt/cdrom `

第二种方式：采用linux物理机或者云服务器挂载iso文件 
– 创建挂载区 
`mkdir /mnt/cdrom `
– 挂载iso文件，先将iso文件拷贝至任意目录中 
`mount -o loop /home/xxx.iso /mnt/cdrom`

## 安装load-generator

进入目录 
`cd /mnt/cdrom/Linux`
安装 
`./installer.sh`

## 卸载load-generator

卸载则使用以下命令： 
`rpm -e LoadGenerator`

## 启动load-generator

在启动之前确保系统支持csh命令 
`cat /etc/shells `
如果不支持，则需要安装csh 
`yum install csh -y`
进入HP_LoadGenerator目录，切换csh命令行 
`cd /opt/HP/HP_LoadGenerator `
`csh`
设置环境变量 
`source env.csh `
进入bin目录并启动 
`m_daemon_setup -install `

## 使用Loadrunner连接负载机

打开Loadrunner Controller，进入Load Generators，添加负载机

设置负载机信息

连接负载机

开启端口54345或关闭防火墙

`iptables -A INPUT -p tcp --dport 端口号 -j ACCEPT`

使用Controller连接，在“UNIX Environment Tab”下选择“Don't use RSH”即可连接Linux负载机。

注意事项

- 启动前需要关闭防火墙，否则无法启动
- 安装过程中若出现错误提示，则根据错误提示安装所需的依赖包即可，使用yum命令安装
- 每次系统重启，需要重新进行设置环境变量及启动步骤，可以将两个步骤加入系统自启动服务中

## load_generator的Docker镜像

### 一、说明

HP官方提供了load_generator的docker镜像，镜像是12.5版本，兼容11.0版本的controller。

[官方镜像地址](https://hub.docker.com/r/hpsoftware/load_generator/)
### 二、安装部署
步骤1：安装docker
```
ubuntu 16.04安装docker
curl -fsSL get.docker.com -o get-docker.sh
sudo sh get-docker.sh --mirror Aliyun
sudo systemctl enable docker
sudo systemctl start docker
```
CentOS7一键部署脚本
```
#!/bin/sh
# @author ling

# 定义显示颜色
RED='\e[1;91m'
GREEN='\e[1;92m'
WITE='\e[1;97m'
NC='\e[0m'


# centos7环境中安装docker
function install_docker_in_contos7()
{
	echo "Install docker in centos7!"
	echo "Remove old docker!"
	yum remove docker docker-common docker-selinux docker-engine && echo -e $GREEN"Remove old docker success!"$NC
	
	echo "Install docker dependent packages!"
	yum install -y yum-utils device-mapper-persistent-data lvm2 && echo -e $GREEN"Install docker dependent packages success!"$NC
	
	echo "Add yum repo!"
	yum-config-manager --add-repo https://mirrors.ustc.edu.cn/docker-ce/linux/centos/docker-ce.repo && echo -e $GREEN"Add yum repo success!"$NC
	
	echo "Install docker-ce!"
	yum makecache fast && yum install -y docker-ce && echo -e $GREEN"Install docker-ce success!"$NC
	
	echo "Chkconfig docker on!"
	systemctl enable docker && systemctl start docker && echo -e $GREEN"Chkconfig docker on success!"$NC
	
	echo "{\"registry-mirrors\": [\"http://hub-mirror.c.163.com\"]}" >> /etc/docker/daemon.json
	systemctl daemon-reload && systemctl restart docker && echo -e $GREEN"Install docker in centos7 success!"$NC
	
	echo "Stop firewalld!"
	systemctl stop firewalld && systemctl disable firewalld && echo -e $GREEN"Stop firewalld success!"$NC
	
	echo "Install iptables services!"
	yum -y install iptables-services && systemctl enable iptables && systemctl start iptables && echo -e $GREEN"Install iptables services success!"$NC
	
	echo "Reload docker!"
	systemctl restart docker && echo -e $GREEN"Reload docker success!"$NC
}

install_docker_in_contos7
```
步骤2：下载最新版本的load_generator镜像，命令如下：
`docker pull hpsoftware/load_generator`
步骤3：load_generator镜像实例化成docker容器，命令如下：
`docker run -d -i -p 54345:54345 --net=host hpsoftware/load_generator`
步骤4：查看容器日志，命令如下：
`docker logs -f `
如果显示如下信息，说明启动成功。

步骤5： 在controller里添加一个load_generator，name填写linux机器的ip。

步骤6：点击【Details】-【Unix Enviroment】勾上【Don’t use RSH】否则会连接不上。

步骤7：点击【Connect】按钮，查看【Status】，若为Ready则表示连接成功。

### 问题1：
```
[loadrunner@localhost bin]$ ./m_daemon_setup start
./m_daemon_setup: ./m_agent_daemon: /lib/ld-linux.so.2: bad ELF interpreter: No such file or directory
```
【解决】：
```
yum install glibc.i686 
```

### 问题2：
```
[loadrunner@localhost bin]$ ./m_daemon_setup start
m_agent_daemon: error while loading shared libraries: libstdc++.so.5: cannot open shared object file: No such file or directory
```
【解决思路】： 
```
yum install libstdc++.i686* 
find / -name libstdc++.so* 
```
找到发现有libstdc++.so.5，在/usr/lib64/libstdc++.so.5中； 

修改上面的LD_LIBRARY_PATH，添加:/usr/lib64

### 问题3：
```
[loadrunner@centos1 bin]$ ./m_daemon_setup start
m_agent_daemon: error while loading shared libraries: libstdc++.so.5: wrong ELF class: ELFCLASS64
```
【解决思路】： 

查看发现是由于版本不对，64位的libstdc++.so.5不适用，应该安装32位的，所以把上一步的操作还原，然后执行yum whatprovides libstdc++.so.5，查看到该动态库是compat-libstdc++-33-3.2.3-72.el7.i686提供，因此执行yum install compat-libstdc++-33-3.2.3-72.el7.i686安装。

### 问题4：
```
[loadrunner@centos1 bin]$ ./m_daemon_setup start
m_agent_daemon ( is down ), 
```
【解决思路】： 
没有提示信息，只有直接查看日志了： 
vim /tmp/m_agent_daemonTihVLp.log
```
DriverLogger: Log started at 21/04/2016 06:33:04 .
 
21/04/2016 06:33:04 Error: Communication error: Failed to get the server host IP by calling the gethostbyname function. (sys error message - Resource temporarily unavailable)  [MsgId: MERR-10344]
21/04/2016 06:33:04 Error: Two Way Communication Error: Function two_way_comm_create_acceptor failed.   [MsgId: MERR-60999]
21/04/2016 06:33:04 Error: Failed to create "launchservice" server.     [MsgId: MERR-29974]
21/04/2016 06:33:04 Warning: Extension liblauncher.so reports error -1 on call to function ExtPerThreadInitialize       [MsgId: MWAR-10485]
21/04/2016 06:33:04 Error: Vuser failed to initialize extension liblauncher.so. [MsgId: MERR-10700]
 
DriverLogger: Log ended at 21/04/2016 06:33:04 .
```
执行env，查看到HOSTNAME=centos1， 
vim /etc/hosts，添加 192.168.108.10 centos1, 注意其中的192.168.108.10是本机IP