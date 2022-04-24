# zk集群数据迁移和恢复

## 一、zk数据迁移，有如下两种方案：

1. 利用zk集群超过半数仍然可用的特性，比如集群中有5个节点，可以将其中1~2个节点割裂出去，再添加1个新的节点，组成新的集群，以此实现数据迁移；
2. 直接拷贝集群的元数据文件到新集群；

但第1种方案并不是最佳选择，例如zk集群连接数负载高，如果此时再减少节点数，则会导致集群负载变得更高，甚至集群崩溃。故采用第2种方案，通过拷贝元数据的方式来实现集群数据迁移和恢复。

## 二、zk数据迁移和恢复的实现思路

1. 搭建好新的zk集群，并且启动集群（此时集群还没有数据）；
2. 停止新集群所有节点的zk进程；
3. 删除新集群所有节点数据目录下的文件，包括：事务日志、快照、epoch文件；
4. 将老集群leader节点的事务日志、快照、epoch文件拷贝到新集群所有节点对应的数据目录下；
5. 重新启动新集群；

## 三、注意事项：

如果新集群的两个epoch文件不删掉的话，会造成新集群无法启动；原因是：如果只是拷贝了老集群的快照、事务日志到新集群，新集群的节点在启动时会识别epoch文件中记录的当前epoch值，然后将这个epoch值和从老集群拷贝过来的元数据中的事务ID（zxid）进行比较，发现并不匹配，就会造成新集群无法正常启动。故需要将新集群中各个节点的epoch文件删除，将老集群的epoch文件、快照文件、事务日志文件一并拷贝到新集群的各个节点。

## 四、zk数据迁移和恢复的具体操作步骤：

### 1、搭建新集群：

1）、rpm -ivh jdk-8u20-linux-x64.rpm 
2）、cd /data/ && tar -zxvf zk_server.tgz ###解压到/data或者/data1
3）、cd /data/ && mv zk_server zk.1   ###myid为1的节点，家目录为/data/zk.1、myid为2的节点，家目录为/data/zk.2
4）、解压之后，可以看到3个目录：
```shell
cd /data/zk.1 && ls -l
zk_data   ###保存zk快照数据的主目录
zk_log    ###保存zk事务日志的主目录
zookeeper  ###程序路径，包含配置文件
```
5）、cd /data/zk.1/zk_data && echo 1 > myid ###配置节点myid，myid为1的节点配置成1，myid为2的节点配置成2，myid为3的节点配置3
6）、cd /data/zk.1/zookeeper/conf && cp -ar zoo.cfg.template zoo.cfg
7）、vim zoo.cfg
```
tickTime=2000
initLimit=10
syncLimit=5
clientPort=2181
autopurge.snapRetainCount=500
autopurge.purgeInterval = 48 
dataDir=/data/zk.1/zk_data  ###myid为2则配置为/data/zk.2/zk_data
dataLogDir=/data/zk.1/zk_log ###myid为2则配置为/data/zk.2/zk_log
server.1=节点1的IP:8880:7770     #节点1的配置
server.2=节点2的IP:8880:7770     #节点2的配置
server.3=节点3的IP:8880:7770      #节点3的配置
```
8）、其余2个节点的安装部署方法也是一样
9）、依次启动3个节点，并检查状态
```
启动：
cd /data/zk.1/zookeeper/bin/ &&  nohup sh zkServer.sh start > zookeeper.out &
检查节点状态：
cd /data/zk.1/zookeeper/bin/ && ./zkServer.sh status 
连接本地节点，查看数据：
cd /data/zk.1/zookeeper/bin/ && ./zkCli.sh -server 127.0.0.1:2181
```
### 2、停止新集群所有节点的zk进程：
```
cd /data/zk.1/zookeeper/bin/ && sh zkServer.sh stop
cd /data/zk.2/zookeeper/bin/ && sh zkServer.sh stop
cd /data/zk.3/zookeeper/bin/ && sh zkServer.sh stop
```
### 3、删除新集群所有节点数据目录下的文件，包括：事务日志、快照、epoch文件（以节点1为例）：
```
cd /data/zk.1/zk_data/version-2 && rm -f snapshot.\* && rm -f acceptedEpoch && rm -f currentEpoch
cd /data/zk.1/zk_log/version-2 && rm -f log.\*
```

### 4、将老集群leader节点的事务日志、快照、epoch文件拷贝到新集群所有节点对应的数据目录下（以leader节点的数据为准）：

1）、备份老集群leader节点的数据目录下的文件（拷贝到本地的新建的zk_meta_dir目录）
最新的log事务日志文件 ###不是所有的log文件，而是最新的log文件
最新的snapshot文件  ###不是所有的snapshot文件，而是最新的snapshot文件
acceptedEpoch文件
currentEpoch文件
2）、将leader节点zk_meta_dir目录的log文件、snapshot文件、Epoch文件分发到新集群每个节点对应的目录，例如节点1的/data/zk.1/zk_data/version-2、/data/zk.1/zk_log/version-2

### 5、重新启动新集群：
以节点1为例：
```
cd /data/zk.1/zookeeper/bin/ &&  nohup sh zkServer.sh start > zookeeper.out &
```
