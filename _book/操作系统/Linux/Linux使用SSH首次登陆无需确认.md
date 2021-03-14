# Linux使用SSH首次登陆无需确认

第一次登录另外一台linux主机的时候，会弹出下面的信息，问是否yes确认登陆和no
```
[root@ghs ~]# ssh -i 2 192.168.1.201 The authenticity of host '192.168.1.201 (192.168.1.201)' can't be established.
ECDSA key fingerprint is 3f:80:ce:88:9c:b9:72:f1:26:71:d0:8e:a4:91:e0:01.
Are you sure you want to continue connecting (yes/no)
```
如果，我们输入yes，就能正常登录。但如果是分发文件的时候，几十台服务器，我们就得不停的输yes，这样很费时间和人力，我们也可以写expect脚本代替执行输入yes，其实还有更简单的方法，输入下面这条命令就可以省去很多事情，也不用专门去写脚本。
```
[root@ghs ~]# echo "StrictHostKeyChecking no" >~/.ssh/config
```
此时，ssh登录远程任意机器都不会问你yes or no.