# Mysql锁表问题解决

## 案例一
```
mysql>show processlist;
```
参看sql语句

一般少的话
```
mysql>kill thread_id;
```
就可以解决了

kill掉第一个锁表的进程, 依然没有改善. 既然不改善, 咱们就想办法将所有锁表的进程kill掉吧, 简单的脚本如下.
```
#!/bin/bash
mysql - u root - e " show processlist " | grep - i " Locked " >> locked_log . txt
for line in ` cat locked_log.txt | awk '{print $1 }' `
do
echo " kill $line ; " >> kill_thread_id . sql
done
```
现在kill_thread_id.sql的内容像这个样子

```
kill 66402982 ;
kill 66402983 ;
kill 66402986 ;
kill 66402991 ;
.....
```
好了, 我们在mysql的shell中执行, 就可以把所有锁表的进程杀死了.
```
mysql > source kill_thread_id.sql
```
当然了, 也可以一行搞定
```
for id in `mysqladmin processlist | grep -i locked | awk '{print $1}'`
do
mysqladmin kill ${id}
done
```
## 案例二

如果大批量的操作能够通过一系列的select语句产生，那么理论上就能对这些结果批量处理。

但是mysql并没用提供eval这样的对结果集进行分析操作的功能。所以只能现将select结果保存到临时文件中，然后再执行临时文件中的指令。

具体过程如下：
```
mysql> SELECT concat('KILL ',id,';') FROM information_schema.processlist WHERE user='root';
+------------------------+
| concat('KILL ',id,';')
+------------------------+
| KILL 3101;      
| KILL 2946;      
+------------------------+
2 rows IN SET (0.00 sec)
mysql> SELECT concat('KILL ',id,';') FROM information_schema.processlist WHERE user='root' INTO OUTFILE '/tmp/a.txt';
Query OK, 2 rows affected (0.00 sec)
mysql> source /tmp/a.txt;
Query OK, 0 rows affected (0.00 sec)
```

## 案例三

MySQL + PHP的模式在大并发压力下经常会导致MySQL中存在大量僵死进程，导致服务挂死。为了自动干掉这些进程，弄了个脚本，放在服务器后台通过crontab自动执行。发现这样做了以后，的确很好的缓解了这个问题。把这个脚本发出来和大家Share.

根据自己的实际需要，做了一些修改：

SHELL脚本:mysqld_kill_sleep.sh

```
#!/bin/sh
mysql_pwd="root的密码"
mysqladmin_exec="/usr/local/bin/mysqladmin"
mysql_exec="/usr/local/bin/mysql"
mysql_timeout_dir="/tmp"
mysql_timeout_log="$mysql_timeout_dir/mysql_timeout.log"
mysql_kill_timeout_sh="$mysql_timeout_dir/mysql_kill_timeout.sh"
mysql_kill_timeout_log="$mysql_timeout_dir/mysql_kill_timeout.log"
$mysqladmin_exec -uroot -p"$mysql_pwd" processlist | awk '{ print $12 , $2 ,$4}' | grep -v Time | grep -v '|' | sort -rn > $mysql_timeout_log
awk '{if($1>30 && $3!="root") print "'""$mysql_exec""' -e " "\"" "kill",$2 "\"" " -uroot " "-p""\"""'""$mysql_pwd""'""\"" ";" }' $mysql_timeout_log > $mysql_kill_timeout_sh
echo "check start ...." >> $mysql_kill_timeout_log
echo `date` >> $mysql_kill_timeout_log
cat $mysql_kill_timeout_sh
```
把这个写到mysqld_kill_sleep.sh。然后chmod 0 mysqld_kill_sleep.sh,chmod u+rx mysqld_kill_sleep.sh，然后用root账户到cron里面运行即可，时间自己调整。

执行之后显示：
```
www# ./mysqld_kill_sleep.sh
/usr/local/bin/mysql -e "kill 27549" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27750" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27840" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27867" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27899" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27901" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27758" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27875" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27697" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27888" -uroot -p"mysql root的密码";
/usr/local/bin/mysql -e "kill 27861" -uroot -p"mysql root的密码";
```
如果确认没有问题了，把最后的cat修改为sh即可。

改写了下上面的脚本:
```
#!/bin/bash
mysql_pwd="密码"
mysql_exec="/usr/local/mysql/bin/mysql"
mysql_timeout_dir="/tmp"
mysql_kill_timeout_sh="$mysql_timeout_dir/mysql_kill_timeout.sh"
mysql_kill_timeout_log="$mysql_timeout_dir/mysql_kill_timeout.log"
$mysql_exec -uroot -p$mysql_pwd -e "show processlist" | grep -i "Locked" >> $mysql_kill_timeout_log
chmod 777 $mysql_kill_timeout_log
for line in `$mysql_kill_timeout_log | awk '{print $1}'`
do
echo "$mysql_exec -uroot -p$mysql_pwd -e \"kill $line\"" >> $mysql_kill_timeout_sh
done
chmod 777 $mysql_kill_timeout_sh
cat $mysql_kill_timeout_sh
```