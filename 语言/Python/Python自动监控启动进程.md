Python自动监控启动进程

```
#!/usr/bin/python  
import subprocess  
import datetime  
res = subprocess.Popen(“ps -ef | grep tomcat”,stdout=subprocess.PIPE,shell=True)  
tomcats=res.stdout.readlines()  
counts=len(tomcats)  
if counts<4:  
dt=datetime.datetime.now()  
fp=open(‘/root/tomcat6.txt’,'a’)  
fp.write(‘tomcat6 stop at %s\n’ % dt.strftime(‘%Y-%m-%d %H:%M:%S’))  
fp.close()  
subprocess.Popen(“/usr/local/tomcat6/bin/startup.sh”,shell=True)
```
作用：监控tomcat进程，如果不存在，则执行startup进行启动。

可以添加为crontab定时任务:
```
crontab -e:
#每十分钟运行该脚本一次
*/10 * * * * root python /root/autorestart-tomcat.py
```
