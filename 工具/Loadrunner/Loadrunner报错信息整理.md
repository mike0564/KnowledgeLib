# Loadrunner报错信息整理

### 【问题】Error -10776  Failed to find .cfg file

错误分析：在loadrunner打开脚本的情况下，运行磁盘清理工具，导致运行打开的脚本时，提示Mdrv error：Failed to find .cfg file MsgId:MERR-10777

解决方法：从其它文件夹拷贝3个文件到不能正常运行脚本的文件夹下：

- default.cfg
- default.usp
- *.prm（将*的位置改为脚本的名字）

再次运行脚本，可以正常运行

### 【问题】 Error -13874: missing newline in C:\Users\Administrator\AppData\Local\Temp\brr_YAR.13\netdir\C\TestingResult\StressTest.2\Script\交强险投保\username.dat

错误分析：The .dat file needs to have an empty line at the bottom of the file. Also, not sure if all your data is on one line,。

解决办法：Put your cursor on it innotepad/whatever you are using to edit your dat files， note that is an empty line at the bottom。

### 【问题】Fatal Error -26000: Not enough memory (12320 bytes) for "new buffer in LrwSrvNetTaskItem::AllocSrvNetBuf".  Aborting

错误分析：报错的时候发现任务管理器里mmdrv.exe 内存占用一直增大,最红mmdrv.exe崩溃（LR兼容C，C语言中内存要手动释放）,或报错原因未脚本中设置使用thread线程执行，线程之间共享内存，所以共享内存出现异常也会导致此报错信息，可以换成进程process方式执行场景。

解决办法：注意内存的使用,尽量减少变量声明,new 的变量用完后要及时用free:

注：web_reg_save_param_ex可能存在消耗资源较多的情况，一般不建议使用，更换成web_reg_save_param进行尝试

### 【问题】回放时lr报错：Error -26488: Could not obtain informationabout submitted file

错误分析：一般情况下上传文件脚本，会报这个错误，原因为找不到文件

解决办法：录制完脚本后，把要上传的文件放到脚本存放的文件夹里面，重新回放就ok

### 【问题】 Error -26601: Decompression function  (wgzMemDecompressBuffer) failed, return code=-5 (Z_BUF_ERROR), inSize=0,  inUse=0, 

问题原因：这个错误为数据包较大，未下载完整或其他原因导致解压错误。

解决办法：
- Runtime-setting--->Internet Protocol--->Preferences--->Options--->General->Network buffer size，设置为122880（默认值为12288）
- Runtime-setting--->Internet Protocol--->Preferences--->Options--->General->Default block size for Dom memory，设置为163840（默认值为16384）

### 【问题】Error-26608: HTTP Status-Code=504(Gateway Time-out)

解决办法：
- 1.在Vuser Generator中的Tools--->Recording Options...--->Recording--->HTTP-based script--->HTML Advanced按钮--->在Script type中选择A script containing explicit URLs only(e.g.web_url,web_submit_data)点击“ok”即可
- 2.runtime-setting, browser emulation, 取消选择download non-HTML resources即可 

### 【问题】Error -26610: HTTP Status-Code=502 (Bad Gateway) for "https://***s.com/login/login"

### 【问题】Error -27727: Step download timeout (120 seconds) has expired when downloading resource(s).

错误分析：对于HTTP协议，默认的超时时间是120秒（可以在Run-time Settings中修改），客户端发送一个请求到端还没有返回结果，则出现超时错误。

解决办法：Set the "Step Timeout caused by resources is a warning" Run-Time Setting to Yes/No to have this message as a warning/error, respectively

### 【问题】 Error -27728: Step download timeout (120 seconds) has expired

错误分析：对于HTTP协议，默认的超时时间是120秒（可以在Run-time Settings中修改），客户端发送一个请求到端还没有返回结果，则出现超时错误。

解决办法：首先在运行环境中对超时进行设置，默认的超时时间可以设置长一些，再设置多次迭代运行，如果还有超时现象，需要在“Runtime Setting”>“Internet Protocol：Preferences”>“Advanced”区域中设置一个“winlnet replay instead of sockets”选项，再回放是否成功

### 【问题】 Error -27791: Server "pcisstage.zsins.com" has shut down the connection prematurely

解决办法：测试中，并发200,300,400人时，LR没报错，在并发500人时，LR报错”Error -27791: Server "172.16.xx.xxx" has shut down the connection prematurely“，同时查看WEB服务器日志：出现这样一条信息：

”INFO: Maximum number of threads (200) created for connector with address null and port 8081“

查看配置文件参数：

```
<Connector port="8080" protocol="HTTP/1.1" 
connectionTimeout="20000" 
redirectPort="8443" />
```

采用的是默认配置，这样在高并发情况下肯定撑不住，所以修改参数配置如下：

```
<Connector port="8081" protocol="HTTP/1.1" 
maxThreads="500" acceptCount="500" connectionTimeout="20000" 
redirectPort="8443" />
```

重新测试，事物全部成功，系统也未报错。

出现”Error -27791: Server "172.16.xx.xxx" has shut down the connection prematurely“的原因即有可能是操作系统网络线程连接资源的原因，也可能是应用软件的原因，当出现问题，随时查看系统日志，能帮助我们更快的定位问题。

### 【问题】Error -27796: Failed to connect to server "10.2.9.147:80":

解决办法：runtime-setting, browser emulation, 将默认勾选的simulate a new vuser on each iteration取消勾选

### 【问题】Error -29724 : Failed to deliver a p2p message from parent to child process, reason - communication error.

可能引起的原因，
- 1.查看压力机的内存和CPU的使用率，CPU使用率有点高，估计引起的此问题
- 2.共享内存溢出，也可能出现这个问题

解决方法 ：
- 1. $installationfolder$\dat\channel_configure.dat
- 2. $installationfolder$\launch_service\dat\channel_configure.dat

在这两个文件中的[general]部分下添加如下配置。

shared_memory_max_size=100 (修改共享内存为100MB，默认是50MB)

重新启动Controller，问题解决。

### 【问题】Error -30935 "Error: Failed to send data by channels – post message failed."

解决办法1： 在LR的controller负载生成器的菜单栏，单击【Diagnostics】》configuration》Web Page Diagnostics【Max Vuser Sampling 10%】设置为【Eenable】。

解决办法2：直接去掉勾选Enable the following diagnostics即可。

### 【问题】Error -35061: No match found for the requested parameter "CorrelationParameter_2". Check whether the requested boundaries exist in the response data. Also, if the data you want to save exceeds 256 bytes, use web_set_max_html_param_len to increase the parameter size [MsgId: MERR-35061]

解决办法1：可以用web_set_max_html_param_len增加参数长度，我试过到99999999共8位

`web_set_max_html_param_len("9999999"); // 以消耗系统资源为代价`

解决办法2：还有，你可以在

```
web_reg_save_param_ex( 
"ParamName=CorrelationParameter_3", "LB=c", 
"RB=>\n<table border", 
```
后面 加上 "NotFound=warning", 保存编译下，就不回再提是错误了。 主要是自动关联造成的左右边界定位不精确，需要保存的值大

### 【问题】Error -60990 : Two Way Communication Error: Function two_way_comm_post_message / two_way_comm_post_message_ex failed.

在做JAVA接口性能测试时，场景在运行中出现：Code - 60990 Error: Two Way Communication Error: Function two_way_comm_post_message /two_way_comm_post_message_ex failed.错误

及Code - 10343 Error: Communication error: Cannot send the message since reached the shared memory buffer max size错误，一般解决的方法如下：

可能的原因一：

共享内存缓存溢出，造成Controller和Load Generator之间通讯出现问题。

解决方法：

修改两个配置文件。
- 1. $installation folder\$\dat\channel_configure.dat
- 2. $installation folder\$\launch_service\dat\channel_configure.dat

在这两个文件中的[general]部分下添加如下配置。

shared_memory_max_size=100 (修改共享内存为100MB，默认是50MB)

重新启动Controller，问题解决。
