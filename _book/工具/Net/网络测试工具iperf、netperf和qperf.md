# 网络测试工具iperf、netperf和qperf

网络性能一般有4个关键测试指标：带宽、时延、丢包、抖动。
带宽一般就是租用的带宽能不能跑满，接口能不能跑满；
时延就是主机响应时间，一般来讲，时延肯定是越低越好；
丢包率和抖动是用来判断网络质量是否稳定的。
测试这些网络性能指标，最常用的就是ping和测速了。
也可以使用下面的专门测试网络的测试工具。

## 一、iperf

### 简介
iperf是一种命令行工具，用于通过测量服务器可以处理的最大网络吞吐量来诊断网络速度问题。它在遇到网络速度问题时特别有用，通过该工具可以确定哪个服务器无法达到最大吞吐量。
### 安装
下载地址：https://iperf.fr/iperf-download.php
也可以使用下列命令进行工具安装：
```shell
#Debian和Ubuntu安装
apt-get install iperf
#CentOS 安装
yum install iperf
```
### 使用
- 必须在测试的两台计算机上同时安装iPerf。如果在个人计算机上使用基于Unix或 Linux的操作系统，则可以在本地计算机上安装iPerf。
- 但是，如果要测试网络提供商的吞吐量，最好使用另一台服务器作为终点，因为本地ISP可能会施加影响测试结果的网络限制。

#### TCP客户端和服务器
iperf需要两个系统，因为一个系统必须充当服务端，另外一个系统充当客户端，客户端连接到需要测试速度的服务端
1. 在需要测试的电脑上，以服务器模式启动iperf
```shell
iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
```
2. 在第二台电脑上，以客户端模式启动iperf连接到第一台电脑，替换ip为iperf服务端的ip地址

```shell
iperf -c 192.168.1.2
------------------------------------------------------------
Client connecting to 192.168.1.2, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[ 3] local 192.168.1.100 port 50616 connected with 192.168.1.2 port 5001
[ ID] Interval Transfer Bandwidth
[ 3] 0.0-10.1 sec 1.27 GBytes 1.08 Gbits/sec
```
3. 这时可以在第一步中的服务端终端看到连接和结果

```shell
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[ 4] local 192.168.1.2 port 5001 connected with 192.168.1.100 port 50616
[ ID] Interval Transfer Bandwidth
[ 4] 0.0-10.1 sec 1.27 GBytes 1.08 Gbits/sec
```
4. 要停止iperf服务进程，请按CTRL+C

#### UDP客户端和服务器
使用iperf，还可以测试通过UDP连接实现的最大吞吐量
1. 启动UDP iperf服务

```shell
iperf -s -u
------------------------------------------------------------
Server listening on UDP port 5001
Receiving 1470 byte datagrams
UDP buffer size: 208 KByte (default)
------------------------------------------------------------
```
2. 将客户端连接到iperf UDP服务器，替换ip为iperf服务端的ip地址

```shell
iperf -c 192.168.1.2 -u
------------------------------------------------------------
Client connecting to 192.168.1.2, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size: 208 KByte (default)
------------------------------------------------------------
[ 3] local 192.168.1.100 port 58070 connected with 192.168.1.2 port 5001
[ ID] Interval Transfer Bandwidth
[ 3] 0.0-10.0 sec 1.25 MBytes 1.05 Mbits/sec
[ 3] Sent 893 datagrams
[ 3] Server Report:
[ 3] 0.0-10.0 sec 1.25 MBytes 1.05 Mbits/sec 0.084 ms 0/ 893 (0%)
```
- 1.05Mbits/sec远低于TCP测试中观察到的值，它也远远低于1GB 的最大出站带宽上限，这是因为默认情况下，iperf将UDP客户端的贷款限制为每秒1Mbit。
3. 可以用-b标志更改此值，将数字替换为要测试的最大带宽速率。如果需要测试网络速度，可以将数字设置为高于网络提供商提供的最大带宽上上限。
```shell
iperf -c 192.168.1.2 -u -b 1000m
```
- 这将告诉客户端我们希望尽可能达到每秒1000Mbits的最大值，该-b标志仅在使用UDP连接时有效，因为iperf未在TCP客户端上设置带宽限制。
```shell
------------------------------------------------------------
Client connecting to 192.168.1.2, UDP port 5001
Sending 1470 byte datagrams
UDP buffer size: 208 KByte (default)
------------------------------------------------------------
[ 3] local 192.168.1.100 port 52308 connected with 192.168.1.2 port 5001
[ ID] Interval Transfer Bandwidth
[ 3] 0.0-10.0 sec 966 MBytes 810 Mbits/sec
[ 3] Sent 688897 datagrams
[ 3] Server Report:
[ 3] 0.0-10.0 sec 966 MBytes 810 Mbits/sec 0.001 ms 0/688896 (0%)
[ 3] 0.0-10.0 sec 1 datagrams received out-of-order
```
#### 双向测试
在某些情况下，可能希望测试两台服务器以获得最大吞吐量。使用iperf提供的内置双向测试功能可以轻松完成此测试。
要测试两个连接，从客户端运行一下命令，替换ip为服务端ip地址
```shell
iperf -c 192.168.1.2 -d
```
iperf将会在此客户端服务器上创建启iperf服务端连接和客户端连接，该连接现在既充当服务器连接又充当客户端连接
```shell
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Client connecting to 192.168.1.2, TCP port 5001
TCP window size: 351 KByte (default)
------------------------------------------------------------
[ 3] local 192.168.1.100 port 50618 connected with 192.168.1.2 port 5001
[ 5] local 192.168.1.100 port 5001 connected with 192.168.1.2 port 58650
[ ID] Interval Transfer Bandwidth
[ 5] 0.0-10.1 sec 1.27 GBytes 1.08 Gbits/sec
[ 3] 0.0-10.2 sec 1.28 GBytes 1.08 Gbits/sec
```
### 选项
#### 服务端专用选项
<table><thead><tr><th>命令行参数</th><th>含义描述</th></tr></thead><tbody><tr><td>-s</td><td>将iperf以server模式启动，例如：iperf3 –s，iperf3默认启动的监听端口为5201，可以通过“-p”选项修改默认监听端口</td></tr><tr><td>-D</td><td>将iperf作为后台守护进程运行，例如：iperf3 -s -D</td></tr></tbody></table>
#### 客户端专用选项
<table><thead><tr><th>命令行参数</th><th>含义描述</th></tr></thead><tbody><tr><td>-c</td><td>将iperf以client模式启动，例如：iperf3 -c 192.168.12.168，其中192.168.12.168是server端的IP地址</td></tr><tr><td>-u</td><td>指定使用UDP协议</td></tr><tr><td>-b [K/M/G]</td><td>指定UDP模式使用的带宽，单位bits/sec。此选项与“-u”选项相关。默认值是1 Mbit/sec</td></tr><tr><td>-t</td><td>指定传输数据包的总时间。iperf将在指定的时间内，重复发送指定长度的数据包。默认是10秒钟</td></tr><tr><td>-n [K/M/G]</td><td>指定传输数据包的字节数，例如：iperf3 -c 192.168.12.168 –n 100M</td></tr><tr><td>-l</td><td>指定读写缓冲区的长度。TCP方式默认大小为8KB，UDP方式默认大小为1470字节</td></tr><tr><td>-P</td><td>指定客户端与服务端之间使用的线程数。默认是1个线程。需要客户端与服务器端同时使用此参数</td></tr><tr><td>-R</td><td>切换数据发送接收模式，例如默认客户端发送，服务器端接收，设置此参数后，数据流向变为客户端接收，服务器端发送</td></tr><tr><td>-w</td><td>指定套接字缓冲区大小，在TCP方式下，此设置为TCP窗口的大小。在UDP方式下，此设置为接受UDP数据包的缓冲区大小，用来限制可以接收数据包的最大值</td></tr><tr><td>-B</td><td>用来绑定一个主机地址或接口，这个参数仅用于具有多个网络接口的主机。在UDP模式下，此参数用于绑定和加入一个多播组</td></tr><tr><td>-M</td><td>设置TCP最大信息段的值</td></tr><tr><td>-N</td><td>设置TCP无延时</td></tr></tbody></table>
#### 客户端与服务器端公用选项
<table><thead><tr><th>命令行参数</th><th>含义描述</th></tr></thead><tbody><tr><td>-f[k/m/g/K/M/G]</td><td>指定带宽输出单位，“[k/m/g/K/M/G]”分别表示以Kbits, Mbits, Gbits, KBytes, MBytes,GBytes显示输出结果，默认以Mbits为单位，例如：iperf3 -c 192.168.12.168 -f M</td></tr><tr><td>-p</td><td>指定服务器端使用的端口或客户端所连接的端口，例如：iperf3 -s -p 9527;iperf3 -c 192.168.12.168 -p 9527</td></tr><tr><td>-i</td><td>指定每次报告之间的时间间隔，单位为秒。如果设置为非零值，就会按照此时间间隔输出测试报告。默认值为1。例如：iperf3 -c 192.168.12.168 -i 2</td></tr><tr><td>-F</td><td>指定文件作为数据流进行带宽测试。例如：iperf3 -c 192.168.12.168 -F web-ixdba.tar.gz</td></tr></tbody></table>

使用命令iperf –help可以查看iperf的帮助

iperf3客户端使用参数简介：
iperf3 -c 服务端ip -p 监听的端口号 -b 带宽 -i 时间间隔(单位秒) -t 持续时间(单位秒) -R(反向传输) -u(采用udp模式)

对于windows版的Iperf，直接将解压出来的iperf.exe和cygwin1.dll复制到%systemroot%目录即可

也可以手动将这里两个文件复制粘贴到C:\Windows\System32，这样cmd可以直接打开

## 二、 netprf

### 简介
Netperf是一种网络性能测量工具,主要针对基于TCP或UDP的传输,Netperf根据应用的不同,可以进行不同模式的网络性能测试，即批量数据传输（bulk data transfer）模式和请求/应答（request/reponse）模式。Netperf测试结果所反映的是一个系统能够以多快的速度向另外一个系统发送数据，以及另外一个系统能够以多块的速度接收数据。
#### 工作原理
Netperf工具以client/server方式工作。server端是netserver,用来侦听来自client端的连接,client端是netperf,用来向server发起网络测试.在client与server之间,首先建立一个控制连接,传递有关测试配置的信息,以及测试的结果:在控制连接建立并传递了测试配置信息以后，client与server之间会再建立一个测试连接,进行来回传递特殊的流量模式,以测试网络的性能。
### 安装
```shell
wget -c "https://codeload.github.com/HewlettPackard/netperf/tar.gz/netperf-2.5.0" -O netperf-2.5.0.tar.gz
tar xvf netperf-2.5.0.tar.gz 
cd netperf-netperf-2.5.0/
./configure 
make && make install
netperf -h或者netperf -V   #有输出说明安装成功
```
或者在下面的网址中找对应操作系统的rpm安装包进行安装
https://pkgs.org/download/netperf

### 使用

#### server端
server端通过以下命令启动即可：
```shell
netserver
```
#### client端
测试TCP_STREAM：
```shell
netperf -t TCP_STREAM -H $netserver_ip -p $PORT -l $testtime -- -m $datagram_size
```
测试TCP_RR：
```shell
netperf -t TCP_RR -H $netserver_ip -l $testtime -p $PORT -- -r $req_size,$rsp_size
```
测试UDP_STREAM：
```shell
netperf -t UDP_STREAM -H $netserver_ip -l $testtime -- -m $datagram_size
```
测试TCP_CRR：
```shell
netperf -t TCP_RR -H netserverip−ltesttime -p PORT−−−rreq_size,$rsp_size
```
默认的输出结果中，只有吞吐量一个性能指标，如果需要得到网络的时延等信息，可通过‘-O’等参数个性化定制：
```shell
netperf -t UDP_STREAM -H $netserver_ip -l $testtime -- -m $datagram_size -O "MIN_LAETENCY,MAX_LATENCY,MEAN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT,THROUGHPUT_UNITS"
```
#### 测试批量（bulk）网络流量的性能
批量数据传输典型的例子有ftp和其它类似的网络应用(即一次传输整个文件)。根据使用传输协议的不同,批量数据传输又分为TCP批量传输和UDP批量传输。

##### TCP_STREAM
Netperf缺省情况下进行TCP批量传输,即-t TCP_STREAM。测试过程中,netperf向netserver发送批量的TCP数据分组,以确定数据传输过程中的吞吐量：
```shell
netperf  -H 10.250.7.241 -l 60 
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.241 (10.250.7.241) port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  
87380  16384  16384    60.12     826.89  
```
从netperf测试的输出结果,可以知道如下信息：
1）远端系统（即server）使用大小为87380字节的socket接收缓冲
2）本地系统（即client）使用大小为16384字节的socket发送缓冲
3）向远端系统发送的测试分组大小为16384字节
4）测试经历的时间为60秒
5）吞吐量的测试结果为826.89 Mbits/秒
在缺省情况下,netperf向发送的测试分组大小设置为本地系统所使用的socket发送缓冲大小。
对于有问题的网络，我们可以修改上面介绍的测试局部参数，来判段是什么原因导致网络的吞吐量异常的！比如修改发送的包的大小来测试，来测试路由的缓存是否合适
```shell
netperf  -H 10.250.7.241 -l 20  -- -m 20480
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.241 (10.250.7.241) port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  20480    20.00     787.26   
 
netperf  -H 10.250.7.241 -l 20  -- -m 16384
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.241 (10.250.7.241) port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    20.00     998.21   
 
netperf  -H 10.250.7.241 -l 20  -- -m 10240
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.241 (10.250.7.241) port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  
 87380  16384  10240    20.01     785.19 
```
从上面的例子看来，增大或者减小都会影响网络的吞吐量！默认的16384是最优的。

##### UDP_STREAM
UDP_STREAM用来测试进行UDP批量传输时的网络性能。注意:此时测试分组的大小不得大于socket的发送与接收缓冲大小，否则netperf会报出错提示：
```shell
netperf -t UDP_STREAM  -H 10.250.7.241 -l 30 -- -m 262155  
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.241 (10.250.7.241) port 0 AF_INET
send_data: data send error: errno 90
netperf: send_omni: send_data failed: Message too long
```
我的测试环境socket 默认的缓冲大小为262144bytes!
```shell
netperf -t UDP_STREAM  -H 10.250.7.220 -l 10  
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.220 (10.250.7.220) port 0 AF_INET
Socket  Message  Elapsed      Messages                
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec
262144   65507   10.00       28783      0    1508.00
262144           10.00       35376           1853.42
```
UDP_STREAM方式的结果中有两行测试数据:
第一行:本地系统的发送统计，这里的吞吐量表示netperf向本地socket发送分组的能力。
第二行:远端系统的接收统计！从上面的结果可以看出10.250.7.220 和 本地的吞吐量是相近的！
在实际环境中,一般远端系统的socket缓冲大小不同于本地系统的socket缓冲区大小,而且由于UDP协议的不可靠性,远端系统的接收吞吐量要远远小于发送出去的吞吐量。
```shell
netperf -t UDP_STREAM  -H 10.250.7.241 -l 10
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.241 (10.250.7.241) port 0 AF_INET
Socket  Message  Elapsed      Messages                
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec
262144   65507   10.00       42962      0    2251.09
262144           10.00       17866            936.13
```
接收的17866少于发送的42962，吞吐量也有较大出入！
#### 测试请求/应答（request/response）网络流量的性能
另一类常见的网络流量类型是应用在client/server结构中的request/response模式。在每次交易（transaction）中，client向server发出小的查询分组，server接收到请求，经处理后返回大的结果数据。
##### TCP_RR
TCP_RR方式的测试对象是多次TCP request和response的交易过程，但是它们发生在同一个TCP连接中，这种模式常常出现在数据库应用中。数据库的client程序与server程序建立一个TCP连接以后，就在这个连接中传送数据库的多次交易过程。
```shell 
netperf -t TCP_RR -H 10.250.7.220 
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.220 (10.250.7.220) port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       10.00    10481.21   
16384  87380 
```
第一行显示本地系统的信息。
第二行显示远端系统的信息。
平均的交易率（transaction rate）为 10481.21 次/秒。注意默认情况下每次交易中的request和response分组的大小都为1个字节，不具有实际意义。
我们可以通过测试相关的参数来改变request和response分组的大小，TCP_RR方式下的参数如下表所示：
|参数|	           说明|
|----|-----|
|-r req,resp	|设置request和reponse分组的大小|
|-s size	   | 设置本地系统的socket发送与接收缓冲大小|
|-S size	    |设置远端系统的socket发送与接收缓冲大小|
|-D	        |对本地与远端系统的socket设置TCP_NODELAY选项|

通过使用-r参数，我们可以进行更有实际意义的测试：
```shell
netperf -t TCP_RR -H 10.250.7.220 -- -r 64 64
MIGRATED TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.220 (10.250.7.220) port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   
16384  87380  64       64      10.00    10631.44   
```
##### TCP_CRR
与TCP_RR不同,TCP_CRR为每次交易建立一个新的TCP连接。最典型的应用就是HTTP，每次HTTP交易是在一条单独的TCP连接中进行的。因此,由于需要不停地建立新的TCP连接,并且在交易结束后拆除TCP连接,交易率一定会受到很大的影响。
```shell
netperf -t TCP_CRR -H 10.250.7.220              
MIGRATED TCP Connect/Request/Response TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.220 (10.250.7.220) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       10.00    2988.56  <===明显减小！
16384  87380 
```
##### UDP_RR
UDP_RR方式使用UDP分组进行request/response的交易过程。由于没有TCP连接所带来的负担，所以交易率一定会有相应的提升。
```shell
netperf -t UDP_RR -H 10.250.7.220
MIGRATED UDP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.250.7.220 (10.250.7.220) port 0 AF_INET : first burst 0
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   
262144 262144 1        1       10.00    97886.03 <===明显上升！  
262144 262144
```

### 选项

根据作用范围的不同，netperf的命令行参数可以分为两大类：全局命令行参数、测试相关的局部参数，两者之间使用--分隔：
Netperf [global options] –-[test-specific options]

其中：

全局命令行参数包括如下选项：

    -H host ：指定远端运行netserver的server IP地址。
    -l testlen：指定测试的时间长度（秒）
    -t testname：指定进行的测试类型，包括TCP_STREAM，UDP_STREAM，TCP_RR，TCP_CRR，UDP_RR

测试相关的局部参数包括如下选项：

    -s size	设置本地系统的socket发送与接收缓冲大小
    -S size	设置远端系统的socket发送与接收缓冲大小
    -m size	设置本地系统发送测试分组的大小
    -M size	设置远端系统接收测试分组的大小
    -D 对本地与远端系统的socket设置TCP_NODELAY选项

### 常见问题
以下几个问题是在netperf使用时遇到较多的几个问题：

1. netserver启动报错
如果netserver启动时端口被占用，则会报以下错误：\
```shell
Unable to start netserver with  'IN(6)ADDR_ANY' port '12865' and family AF_UNSPEC
```
解决方法：

指定一个未使用的端口给netserver,如：
```shell
netserver -p 49999
```
2. 不同子网下的主机使用netperf时连接超时
解决方法：netperf在设计时关闭了此功能，需要通过额外参数进行打开‘-R 1’，如：
```shell
netperf -t TCP_STREAM -H $netserver_ip -P $PORT -l $testtime -- -R 1 -m $datagram_size
```

## 三、qperf

### 简介
网络性能主要有两个指标是带宽和延时。延迟决定最大的QPS(Query Per Second)，而带宽决定了可支撑的最大负荷。
qperf和iperf/netperf一样可以评测两个节点之间的带宽和延时。可以在测试tcp/ip协议和RDMA传输。不过相比netperf和iperf，支持RDMA是qperf工具的独有特性。

### 安装

```shell
yum install qperf
```
同时会安装两个依赖包(libibverbs, librdmacm),是直接和rdma功能相关的，不然无法启动rdma功能。也可以通过，https://pkgs.org/download/qperf 官方网页下载RPM包进行安装。

### 使用
qperf是测试两个节点之间的带宽和延时的，为此需要一个当作服务端，一个当作客户端。其中服务端直接运行qperf, 无需任何参数。
#### 服务端节点
直接运行如下，无需任何参数
```shell
#qperf
```
默认开启端口号：19765
通过netstat查看，如下:
```shell
#netstat –tunlup
tcp 0 0 0.0.0.0:19765 0.0.0.0:* LISTEN 53755/qperf
```
#### 客户端
客户端运行获取带宽、延时情况，运行过程中不需要指定端口号，只要指定主机名或者ip地址即可。文章中后续命令都是在客户端中进行执行。
##### TCP带宽测试
最简单的格式是客户端使用两个参数：一个是服务端的名字，另一个是本次测试的命名（例如tcp_bw TCP带宽测试）。
```shell
#qperf 11.165.67.18 tcp_bw
```
这个是输出tcp带宽。
##### TCP延时测试
测试tcp延时，如下：
```shell
#qperf 11.165.67.18 tcp_lat

tcp_bw:
bw = 1.17 GB/sec
tcp_lat:
latency = 61.3 us
```
可以同时测试tcp带宽和tcp延时，如下：
```shell
#qperf 11.165.67.18 tcp_bw tcp_lat
tcp_bw:
bw = 1.17 GB/sec
tcp_lat:
latency = 61.3 us
```
UDP协议测试同TCP协议测试类似，只需命令参数中将tcp_bw和tcp_lat改成udp_bw和udp_lat即可。
##### 指定测试时间
有些场景下我们需要进行带负载的长时间稳定性测试，可以通过指定测试运行时间（使用-t参数）来实现。例如测试10秒tcp带宽,可以使用-t参数，如下：
```shell
#qperf 11.165.67.18 -t 10 tcp_bw
```
##### 循环loop遍历测试
在做网卡性能摸底测试的时候，很多时候需要得到网卡的带宽和延时性能曲线。通过qperf提供的循环loop测试，可以一个命令得到所有数据。循环多次测试，每次改变消息大小，例如从16K增加到64K，每次大小翻倍直到64K。
```shell
#qperf 11.165.67.18 -oo msg_size:1:64K:*2 -vu tcp_bw tcp_lat
tcp_bw:
bw = 3.06 MB/sec
msg_size = 1 bytes
tcp_bw:
bw = 6.15 MB/sec
msg_size = 2 bytes
tcp_bw:
bw = 12 MB/sec
msg_size = 4 bytes
tcp_bw:
bw = 24 MB/sec
msg_size = 8 bytes
tcp_bw:
bw = 48.6 MB/sec
msg_size = 16 bytes
tcp_bw:
bw = 93.5 MB/sec
msg_size = 32 bytes
tcp_bw:
bw = 176 MB/sec
msg_size = 64 bytes
tcp_bw:
bw = 343 MB/sec
msg_size = 128 bytes
tcp_bw:
bw = 612 MB/sec
msg_size = 256 bytes
tcp_bw:
bw = 904 MB/sec
msg_size = 512 bytes
tcp_bw:
bw = 1.18 GB/sec
msg_size = 1 KiB (1,024)
tcp_bw:
bw = 1.17 GB/sec
msg_size = 2 KiB (2,048)
tcp_bw:
bw = 1.15 GB/sec
msg_size = 4 KiB (4,096)
tcp_bw:
bw = 1.17 GB/sec
msg_size = 8 KiB (8,192)
tcp_bw:
bw = 1.17 GB/sec
msg_size = 16 KiB (16,384)
tcp_bw:
bw = 1.17 GB/sec
msg_size = 32 KiB (32,768)
tcp_bw:
bw = 1.17 GB/sec
msg_size = 64 KiB (65,536)
tcp_lat:
latency = 61.5 us
msg_size = 1 bytes
tcp_lat:
latency = 61.8 us
msg_size = 2 bytes
tcp_lat:
latency = 61.9 us
msg_size = 4 bytes
tcp_lat:
latency = 29.8 us
msg_size = 8 bytes
tcp_lat:
latency = 61.5 us
msg_size = 16 bytes
tcp_lat:
latency = 62.2 us
msg_size = 32 bytes
tcp_lat:
latency = 61.6 us
msg_size = 64 bytes
tcp_lat:
latency = 61.5 us
msg_size = 128 bytes
tcp_lat:
latency = 61.9 us
msg_size = 256 bytes
tcp_lat:
latency = 61.9 us
msg_size = 512 bytes
tcp_lat:
latency = 61.7 us
msg_size = 1 KiB (1,024)
tcp_lat:
latency = 62.7 us
msg_size = 2 KiB (2,048)
tcp_lat:
latency = 62.6 us
msg_size = 4 KiB (4,096)
tcp_lat:
latency = 70.4 us
msg_size = 8 KiB (8,192)
tcp_lat:
latency = 141 us
msg_size = 16 KiB (16,384)
tcp_lat:
latency = 152 us
msg_size = 32 KiB (32,768)
tcp_lat:
latency = 186 us
msg_size = 64 KiB (65,536)
```
可以最后将测试数据图形化。得到msg_size从1到64K变化的过程中，带宽,延时增长趋势和临界点。这个临界点对于服务器性能评估是很有帮助的。

##### RDMA测试
如果网卡支持RDMA功能，例如IB卡，那么可以进行RDMA性能测试：
#qperf  11.165.67.18 ud_bw

### 选项

qperf SERVERNODE [OPTIONS] TESTS
SERVERNODE 为服务端的地址
TESTS 为需要测试的指标，使用帮助命令 qperf --help tests 可以查看到 qperf 支持的所有测量指标，可以一条命令中带多个测试项，这里介绍常用的有：
    tcp_bw —— TCP流带宽
    tcp_lat —— TCP流延迟
    udp_bw —— UDP流带宽
    udp_lat —— UDP流延迟
    conf —— 显示两端主机配置

OPTIONS 是可选字段，使用帮助命令 qperf --help options 可以查看所有支持的可选参数，这里介绍常用的参数：

    --time/-t —— 测试持续的时间，默认为 2s
    --msg_size/-m —— 设置报文的大小，默认测带宽是为 64KB，测延迟是为 1B
    --listen_port/-lp —— 设置与服务端建立连接的端口号，默认为 19765
    --verbose/-v —— 提供更多输出的信息，可以更多尝试一下 -vc 、 -vs 、 -vt 、 -vu 等等
