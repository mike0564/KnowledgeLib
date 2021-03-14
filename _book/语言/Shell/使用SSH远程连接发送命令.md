# 使用SSH远程连接发送命令
## Shell远程执行：

经常需要远程到其他节点上执行一些shell命令，如果分别ssh到每台主机上再去执行很麻烦，因此能有个集中管理的方式就好了。以下介绍两种shell命令远程执行的方法。

## 对于脚本的方式：

有些远程执行的命令内容较多，单一命令无法完成，考虑脚本方式实现：
```
#!/bin/bash
ssh user@remoteNode > /dev/null 2>&1 << eeooff
cd /home
touch abcdefg.txt
exit
eeooff
echo done!
```
远程执行的内容在“<< eeooff ” 至“ eeooff ”之间，在远程机器上的操作就位于其中，注意的点：

<< eeooff，ssh后直到遇到eeooff这样的内容结束，eeooff可以随便修改成其他形式。

重定向目的在于不显示远程的输出了

在结束前，加exit退出远程节点

## SSH命令格式
```
usage: ssh [-1246AaCfgKkMNnqsTtVvXxYy] [-b bind_address] [-c cipher_spec]  
           [-D [bind_address:]port] [-e escape_char] [-F configfile]  
           [-I pkcs11] [-i identity_file]  
           [-L [bind_address:]port:host:hostport]  
           [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]  
           [-R [bind_address:]port:host:hostport] [-S ctl_path]  
           [-W host:port] [-w local_tun[:remote_tun]]  
           [user@]hostname [command]  
```
## 主要参数说明
```
-l 指定登入用户
-p 设置端口号
-f 后台运行，并推荐加上 -n 参数
-n 将标准输入重定向到 /dev/null，防止读取标准输入。如果在后台运行ssh的话（-f选项），就需要这个选项。
-N 不执行远程命令，只做端口转发
-q 安静模式，忽略一切对话和错误提示
-T 禁用伪终端配置
-t （tty）为远程系统上的ssh进程分配一个伪tty（终端）。如果没有使用这个选项，当你在远程系统上运行某条命令的时候，ssh不会为该进程分配tty（终端）。相反，ssh将会把远端进程的标准输入和标准输出附加到ssh会话上去，这通常就是你所希望的（但并非总是如此）。这个选项将强制ssh在远端系统上分配tty，这样那些需要tty的程序就能够正常运行。
-v verbose）显示与连接和传送有关的调试信息。如果命令运行不太正常的话，这个选项就会非常有用。
```
## ssh控制远程主机，远程执行命令步骤

第一步，设置ssh免认证，免认证就是不用密码认证就可以直接登录，这在写脚本服务器控制时特别有用。

每二步，就是到远端服务器上去执行命令

## 准备工作

基于公私钥认证（可参考：Linux配置SSH密钥登录详解及客户端测试使用无密码登录）或者用户名密码认证（可参考：SSH使用expect自动输入密码、命令实现非交互式密码授权）能确保登录到远程服务器

cmd如果是脚本，注意绝对路径问题（相对路径在远程执行时就是坑）

基于公私钥认证远程登录可能存在的不足

这个可以满足我们大多数的需求，但是通常运维部署很多东西的时候需要root权限，但是有几处限制：
- 远程服务器禁止root用户登录
- 在远程服务器脚本里转换身份用expect需要send密码，这样不够安全

## ssh 执行远程命令格式
```
ssh [options] [user@]host [command]
```
其中，host为想要连接到的OpenSSH服务器（远程系统）的名称，它是惟一的必需参数。host可以是某个本地系统的名称，也可以是因特网上某个系统的FQDN（参见术语表）或者是一个IP地址。命令ssh host登录到远程系统host，使用的用户名与正在本地系统上使用的用户名完全相同。如果希望登录的用户名与正在本地系统上使用的用户名不同，那么就应该包含user@。根据服务器设置的不同，可能还需要提供口令。

## 打开远程shell

如果没有提供command参数，ssh就会让你登录到host上去。远程系统显示一个shell提示符，然后就能够在host上运行命令。命令exit将会关闭与host的连接，并返回到本地系统的提示符。

例：命令行执行登录并且在目标服务器上执行命令
```
ssh user@remoteNode "cd /home ; ls"
```
基本能完成常用的对于远程节点的管理了，几个注意的点：
- 如果想在远程机器上连续执行多条命令，可以用单引号或者双引号将这些命令括起来。如果不加单引号或者双引号，第二个ls命令在本地执行。例如 ssh user@node cd /local ls 则 ls 只会执行 cd /local 命令，ls命令在本地执行，加了双引号或者单引号，则被括起来的命令被当做ssh命令的一个参数，所以会在远程连续执行。
- 分号，两个命令之间用分号隔开

例：在目标服务器上执行批量的命令。
```
#!/bin/bash  
ssh root@192.168.0.23   < < remotessh  
killall -9 java  
cd /data/apache-tomcat-7.0.53/webapps/  
exit  
remotessh  
```
远程执行的内容在"< < remotessh " 至" remotessh "之间，在远程机器上的操作就位于其中，注意的点：<< remotessh，ssh后直到遇到remotessh这样的内容结束，remotessh可以随便修改成其他形式。在结束前，加exit退出远程节点

如果不想日志文件在本机出现可以修改配置
```
ssh root@192.168.0.23 > /dev/null 2>&1   < < remotessh
```
## ssh的-t参数

-t      Force pseudo-tty allocation.  This can be used to execute arbitrary screen-based programs on a remote machine, which can be very useful, e.g. when implementing menu services.  Multiple -t options force tty allocation, even if ssh has no local tty.  
中文翻译一下：就是可以提供一个远程服务器的虚拟tty终端，加上这个参数我们就可以在远程服务器的虚拟终端上输入自己的提权密码了，非常安全
命令格式
```
ssh -t -p $port $user@$ip  'cmd' 
```
示例脚本
```
#!/bin/bash  
  
#变量定义  
ip_array=("192.168.1.1" "192.168.1.2" "192.168.1.3")  
user="test1"  
remote_cmd="/home/test/1.sh"  
  
#本地通过ssh执行远程服务器的脚本  
for ip in ${ip_array[*]}  
do  
    if [ $ip = "192.168.1.1" ]; then  
        port="7777"  
    else  
        port="22"  
    fi  
    ssh -t -p $port $user@$ip "remote_cmd"  
done  
```
这个方法还是很方便的，-t虚拟出一个远程服务器的终端，在多台服务器同时部署时确实节约了不少时间啊！

例：查看远程服务器的cpu信息
假设远程服务器IP是192.168.110.34
```
ssh -l www-online 192.168.110.34 “cat /proc/cpuinfo”
```
例：执行远程服务器的sh文件
首先在远程服务器的/home/www-online/下创建一个uptimelog.sh脚本
```
#!/bin/bash  
uptime >> 'uptime.log'  
exit 0
```
使用chmod增加可执行权限
```
chmod u+x uptimelog.sh
```
在本地调用远程的uptimelog.sh
```
ssh -l www-online 192.168.110.34 "/home/www-online/uptimelog.sh"
```
执行完成后,在远程服务器的/home/www-online/中会看到uptime.log文件，显示uptime内容
```
www-online@nmgwww34:~$ tail -f uptime.log  
21:07:34 up 288 days,  8:07,  1 user,  load average: 0.05, 0.19, 0.31  
```
例：执行远程后台运行sh
首先把uptimelog.sh修改一下,修改成循环执行的命令。作用是每一秒把uptime写入uptime.log
```
#!/bin/bash  
  
while :  
do  
  uptime >> 'uptime.log'  
  sleep 1  
done  
  
exit 0
```
我们需要这个sh在远程服务器以后台方式运行，命令如下：
```
ssh -l www-online 192.168.110.34 “/home/www-online/uptimelog.sh &”
```
```
www-online@onlinedev01:~$ ssh -l www-online 192.168.110.34 "/home/www-online/uptimelog.sh &"  
www-online@192.168.110.34's password: 
```
输入密码后，发现一直停住了，而在远程服务器可以看到，程序已经以后台方式运行了。
```
www-online@nmgwww34:~$ ps aux|grep uptimelog.sh  
1007     20791  0.0  0.0  10720  1432 ?        S    21:25   0:00 /bin/bash /home/www-online/uptimelog.sh
```
原因是因为uptimelog.sh一直在运行，并没有任何返回，因此调用方一直处于等待状态。

我们先kill掉远程服务器的uptimelog.sh进程，然后对应此问题进行解决。

## ssh 调用远程命令后不能自动退出解决方法

可以将标准输出与标准错误输出重定向到/dev/null，这样就不会一直处于等待状态。
```
ssh -l www-online 192.168.110.34 “/home/www-online/uptimelog.sh > /dev/null 2>&1 &”
```
```
www-online@onlinedev01:~$ ssh -l www-online 192.168.110.34 "/home/www-online/uptimelog.sh > /dev/null 2>&1 &"  
www-online@192.168.110.34's password:  
www-online@onlinedev01:~$  
```
但这个ssh进程会一直运行在后台，浪费资源，因此我们需要自动清理这些进程。

实际上，想ssh退出，我们可以在ssh执行完成后kill掉ssh这个进程来实现。

首先，创建一个sh执行ssh的命令,这里需要用到ssh的 -f 与 -n 参数，因为我们需要ssh也以后台方式运行，这样才可以获取到进程号进行kill操作。

创建ssh_uptimelog.sh，脚本如下
```
#!/bin/bash  
  
ssh -f -n -l www-online 192.168.110.34 "/home/www-online/uptimelog.sh &" # 后台运行ssh  
  
pid=$(ps aux | grep "ssh -f -n -l www-online 192.168.110.34 /home/www-online/uptimelog.sh" | awk '{print $2}' | sort -n | head -n 1) # 获取进程号  
  
echo "ssh command is running, pid:${pid}"  
  
sleep 3 && kill ${pid} && echo "ssh command is complete" # 延迟3秒后执行kill命令，关闭ssh进程，延迟时间可以根据调用的命令不同调整  
  
exit 0  
```
可以看到，3秒后会自动退出
```
www-online@onlinedev01:~$ ./ssh_uptimelog.sh  
www-online@192.168.110.34's password:  
ssh command is running, pid:10141  
ssh command is complete  
www-online@onlinedev01:~$  
```
然后查看远程服务器，可以见到 uptimelog.sh 在后台正常执行。
```
www-online@nmgwww34:~$ ps aux|grep uptime  
1007     28061  0.1  0.0  10720  1432 ?        S    22:05   0:00 /bin/bash /home/www-online/uptimelog.sh  
```
查看uptime.log，每秒都有uptime数据写入。
```
www-online@nmgwww34:~$ tail -f uptime.log  
22:05:44 up 288 days,  9:05,  1 user,  load average: 0.01, 0.03, 0.08  
22:05:45 up 288 days,  9:05,  1 user,  load average: 0.01, 0.03, 0.08  
22:05:46 up 288 days,  9:05,  1 user,  load average: 0.01, 0.03, 0.08  
22:05:47 up 288 days,  9:05,  1 user,  load average: 0.01, 0.03, 0.08  
22:05:48 up 288 days,  9:05,  1 user,  load average: 0.01, 0.03, 0.08  
```
附录：

### 1、单引号和双引号在ssh命令中的区别：
以一个例子来说明问题，

假设本地机器上配置了JAVA环境变量，在本地执行 echo $JAVA_HOME=/opt/jdk

假若我想查看远程机器上的JAVA环境变量，则只能使用单引号了，ssh user@node ‘ echo \$JAVA ‘, 则是’ ‘ 中的\$JAVA不会被shell解析，而是当做一个字符串，此时参数 echo \$JAVA 传递给了 ssh；

如果我们使用 ssh user@node ” echo \$JAVA “，则 shell 首先会解析\$JAVA,得到它的值，则该命令就变成了 ssh user@node ‘ echo /opt/jdk ‘ 了

### 2、可能遇到的问题
问题：远程登录主机时出现Pseudo-terminal will not be allocated because stdin is not a terminal. 错误

解决方案：字面意思是伪终端将无法分配，因为标准输入不是终端。

所以需要增加-t -t参数来强制伪终端分配，即使标准输入不是终端。

to force pseudo-tty allocation even if stdin isn’t a terminal.

参考样例如下:
```
ssh -t -t user1@host1 -p 9527
```