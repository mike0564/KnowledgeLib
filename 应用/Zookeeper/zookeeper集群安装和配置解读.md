# zookeeper集群安装和配置解读

## 一、集群安装

### 1、下载好的zk进行解压

解压文件，进行存放到指定目录！

```text
tar -zxf zookeeper-3.4.10.tar.gz -C /root/programs/
```

### 2、创建数据和日志目录

数据目录和日志目录，创建的目的是zk运行过程中所产生的数据。

```text
mkdir zkData
mkdir zkLog
```

### 3、修改配置

进入zk下的conf配置文件目录

```text
# cd conf/
# cp zoo_sample.cfg zoo.cfg
# vim zoo.cfg 
 
# The number of milliseconds of each tick
tickTime=2000
# The number of ticks that the initial 
# synchronization phase can take
initLimit=10
# The number of ticks that can pass between 
# sending a request and getting an acknowledgement
syncLimit=5
# the directory where the snapshot is stored.
# do not use /tmp for storage, /tmp here is just 
# example sakes.
dataDir=/root/programs/zookeeper-3.4.10/zkData
dataLogDir=/root/programs/zookeeper-3.4.10/zkLog
# the port at which the clients will connect
clientPort=2181
# the maximum number of client connections.
# increase this if you need to handle more clients
#maxClientCnxns=60
#
# Be sure to read the maintenance section of the 
# administrator guide before turning on autopurge.
#
# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
#
# The number of snapshots to retain in dataDir
autopurge.snapRetainCount=3
# Purge task interval in hours
# Set to "0" to disable auto purge feature
autopurge.purgeInterval=1
 
server.1=master:2888:3888
server.2=slave1:2888:3888
server.3=slave2:2888:3888
```
### 4、分发到集群节点

本环境已进行集群间的互信，进行分发到各个服务器master slave1 slave2中。

```text
scp -rp zookeeper-3.4.10 slave1:/root/programs/
scp -rp zookeeper-3.4.10 slave2:/root/programs/
```

### 5、分别添加id

master slave1 slave2集群中，分别进行添加myid.

```text
echo "1" > /root/programs/zookeeper-3.4.10/zkData/myid
echo "2" > /root/programs/zookeeper-3.4.10/zkData/myid
echo "3" > /root/programs/zookeeper-3.4.10/zkData/myid
```

### 6、添加环境变量

master slave1 slave2，每个环境进行环境配置

```text
# vim ~/.bashrc 
```

**刷新配置文件**

```text
# source ~/.bashrc 
```

## 二、集群常用命令

### 2.1服务端server

#### 1、 启动zkserver服务

```text
/zookeeper-3.4.10# bin/zkServer.sh start
ZooKeeper JMX enabled by default
Using config: /root/dong/lib/zookeeper-3.4.10/bin/../conf/zoo.cfg
Starting zookeeper ... STARTED
```

#### 2、查看zkServer状态

```text
[root@master zookeeper-3.4.10]# zkServer.sh status
ZooKeeper JMX enabled by default
Using config: /root/programs/zookeeper-3.4.10/bin/../conf/zoo.cfg
Mode: follower
```

#### 3、停止zkserver

```text
/zookeeper-3.4.10# bin/zkServer.sh stop
ZooKeeper JMX enabled by default
Using config: /root/dong/lib/zookeeper-3.4.10/bin/../conf/zoo.cfg
Stopping zookeeper ... STOPPED
```

### 2.2 客户端client

#### 2.2.1 启动客户端

```text
/zookeeper-3.4.10# bin/zkCli.sh
Connecting to localhost:2181
......
```

#### 2.2.2 退出客户端

```text
[zk: localhost:2181(CONNECTED) 1] ls / 
[zookeeper]
[zk: localhost:2181(CONNECTED) 2] quit
Quitting...
2021-01-31 18:02:30,902 [myid:] - INFO  [main:ZooKeeper@684] - Session: 0x17757e264880000 closed
2021-01-31 18:02:30,903 [myid:] - INFO  [main-EventThread:ClientCnxn$EventThread@519] - EventThread shut down for session: 0x17757e264880000
```

## 三、配置解读

### 3.1. tickTime=2000

通信心跳数，zk服务器与客户端心跳时间，单位毫秒zk使用的基本时间，服务器之间或客户端与服务器之间维持心跳的时间间隔，也就是每个ticktime时间就会发送一个心跳，时间单位为毫秒。它用于心跳机制，并且设置最小的session超时时间为俩倍心跳时间。（session的最小超时时间是2*ticktime）

### 3.2. initLimit=10

LF初始通信时限
集群中的Follower跟随者服务器与Leader领导者服务器之间初始连接时容忍的最多心跳数（ticktime的数量），用它来限定集群中的zookeeper服务器连接到Leader的时限

### 3.3. syncLimit=5

LF同步通信时限
集群中Leader与Follower之间的最大响应时间单位，假如响应时间超过 syncLimit\*tickTime,Leader人为Follower死掉，从服务器列表中删除Follower

### 3.4. dataDir

数据文件目录+数据持久化路径
主要用于保存zook中的数据

### 3.4. dataLogDir

主要用于保存zook中的日志文件

### 3.6. clientPort=2181

客户端连接端口
监听客户端连接的端口

### 3.7.autopurge.purgeInterval

3.4.0及之后版本，ZK提供了自动清理事务日志和快照文件的功能，这个参数指定了清理频率，单位是小时，需要配置一个1或更大的整数，默认是0，表示不开启自动清理功能。

### 3.8.autopurge.snapRetainCount

这个参数和上面的参数搭配使用，这个参数指定了需要保留的文件数目。默认是保留3个。
