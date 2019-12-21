# Python实现对Linux服务器的监控

Linux 系统为管理员提供了非常好的方法，使其可以在系统运行时更改内核，而不需要重新引导内核系统，这是通过/proc 虚拟文件系统实现的。/proc 文件虚拟系统是一种内核和内核模块用来向进程（process）发送信息的机制（所以叫做“/proc”），这个伪文件系统允许与内核内部数据结构交互，获取有关进程的有用信息，在运行中（on the fly）改变设置（通过改变内核参数）。与其他文件系统不同，/proc 存在于内存而不是硬盘中。

proc 文件系统提供的信息如下：

- 进程信息：系统中的任何一个进程，在 proc 的子目录中都有一个同名的进程 ID，可以找到 cmdline、mem、root、stat、statm，以及 status。某些信息只有超级用户可见，例如进程根目录。每一个单独含有现有进程信息的进程有一些可用的专门链接，系统中的任何一个进程都有一个单独的自链接指向进程信息，其用处就是从进程中获取命令行信息。
- 系统信息：如果需要了解整个系统信息中也可以从/proc/stat 中获得，其中包括 CPU 占用情况、磁盘空间、内存对换、中断等。
- CPU 信息：利用/proc/CPUinfo 文件可以获得中央处理器的当前准确信息。
- 负载信息：/proc/loadavg 文件包含系统负载信息。
- 系统内存信息：/proc/meminfo 文件包含系统内存的详细信息，其中显示物理内存的数量、可用交换空间的数量，以及空闲内存的数量等。

/proc 目录中的主要文件的说明：

|文件或目录名称|	相关描述|
|------------|--------|
|apm|	高级电源管理信息|
|cmdline|	这个文件给出了内核启动的命令行|
|cpuinfo|	中央处理器信息|
|devices|	可以用到的设备（块设备/字符设备）|
|dma|	显示当前使用的 DMA 通道|
|filesystems|	核心配置的文件系统|
|ioports|	当前使用的 I/O 端口|
|interrupts|	这个文件的每一行都有一个保留的中断|
|kcore|	系统物理内存映像|
|kmsg|	核心输出的消息，被送到日志文件|
|mdstat|	这个文件包含了由 md 设备驱动程序控制的 RAID 设备信息|
|loadavg|	系统平均负载均衡|
|meminfo|	存储器使用信息，包括物理内存和交换内存|
|modules|	这个文件给出可加载内核模块的信息。lsmod 程序用这些信息显示有关模块的名称，大小，使用数目方面的信息|
|net|	网络协议状态信息|
|partitions|	系统识别的分区表|
|pci|	pci 设备信息|
|scsi|	scsi 设备信息|
|self|	到查看/proc 程序进程目录的符号连接|
|stat|	这个文件包含的信息有 CPU 利用率，磁盘，内存页，内存对换，全部中断，接触开关以及赏赐自举时间|
|swaps|	显示的是交换分区的使用情况|
|uptime|	这个文件给出自从上次系统自举以来的秒数，以及其中有多少秒处于空闲|
|version|	这个文件只有一行内容，说明正在运行的内核版本。可以用标准的编程方法进行分析获得所需的系统信息|

*注:下面几个例子都是使用 Python 脚本读取/proc 目录中的主要文件来实现实现对 Linux 服务器的监控的。*

## 对CPU监测

```
[root@node6 py]# cat cpu1.py  
#!/usr/bin/python  
from __future__ import print_function  
from collections import OrderedDict  
import pprint
def CPUinfo(): 
    ''' Return the information in /proc/CPUinfo  
    as a dictionary in the following format:  
    CPU_info['proc0']={...}  
    CPU_info['proc1']={...}  
    '''  
    CPUinfo=OrderedDict()  
    procinfo=OrderedDict()
    nprocs = 0 
    with open('/proc/cpuinfo') as f:  
        for line in f:  
            if not line.strip():  
                # end of one processor  
                CPUinfo['proc%s' % nprocs] = procinfo  
                nprocs=nprocs+1  
                # Reset  
                procinfo=OrderedDict()  
            else:  
                if len(line.split(':')) == 2:  
                    procinfo[line.split(':')[0].strip()] = line.split(':')[1].strip()  
                else:  
                    procinfo[line.split(':')[0].strip()] = ''  
    return CPUinfo
if __name__=='__main__': 
    CPUinfo = CPUinfo()  
    for processor in CPUinfo.keys():  
        print(CPUinfo[processor]['model name'])
```
作用：读取/proc/CPUinfo 中的信息，返回 list，每核心一个 dict。其中 list 是一个使用方括号括起来的有序元素集合。List 可以作为以 0 下标开始的数组。Dict 是 Python 的内置数据类型之一, 它定义了键和值之间一对一的关系。OrderedDict 是一个字典子类，可以记住其内容增加的顺序。常规 dict 并不跟踪插入顺序，迭代处理时会根据键在散列表中存储的顺序来生成值。在 OrderedDict 中则相反，它会记住元素插入的顺序，并在创建迭代器时使用这个顺序。

可以使用 Python 命令运行脚本 cpu1.py 结果如下：
```
[root@node6 py]# python cpu1.py  
Intel(R) Core(TM) i5 CPU       M 430  @ 2.27GHz  
Intel(R) Core(TM) i5 CPU       M 430  @ 2.27GHz
```
也可以使用 chmod 命令添加权限收直接运行 cpu1.py结果如下:
```
[root@node6 py]# chmod +x cpu1.py  
[root@node6 py]# ./cpu1.py   
Intel(R) Core(TM) i5 CPU       M 430  @ 2.27GHz  
Intel(R) Core(TM) i5 CPU       M 430  @ 2.27GHz
```
## 对系统负载监测
```
[root@node6 py]# cat cpu2.py  
#!/usr/bin/python 
import os   
def load_stat():   
    loadavg = {}   
    f = open("/proc/loadavg")   
    con = f.read().split()   
    f.close()   
    loadavg['lavg_1']=con[0]   
    loadavg['lavg_5']=con[1]   
    loadavg['lavg_15']=con[2]   
    loadavg['nr']=con[3]   
    loadavg['last_pid']=con[4]   
    return loadavg   
print "loadavg",load_stat()['lavg_15']
```
作用：读取/proc/loadavg 中的信息，import os ：Python 中 import 用于导入不同的模块，包括系统提供和自定义的模块。其基本形式为：import 模块名 [as 别名]，如果只需要导入模块中的部分或全部内容可以用形式：from 模块名 import *来导入相应的模块。OS 模块 os 模块提供了一个统一的操作系统接口函数，os 模块能在不同操作系统平台如 nt，posix 中的特定函数间自动切换，从而实现跨平台操作。

可以使用 Python 命令运行脚本 cpu2.py 结果如下：
```
[root@node6 py]# python cpu2.py  
loadavg 0.10
```

## 对内存信息的获取
```
[root@node6 py]# cat mem.py  
#!/usr/bin/python
from __future__ import print_function 
from collections import OrderedDict
def meminfo(): 
    ''' Return the information in /proc/meminfo  
    as a dictionary '''  
    meminfo=OrderedDict()
    with open('/proc/meminfo') as f: 
        for line in f:  
            meminfo[line.split(':')[0]] = line.split(':')[1].strip()  
    return meminfo
if __name__=='__main__': 
    #print(meminfo())  
    meminfo = meminfo()  
    print('Total memory: {0}'.format(meminfo['MemTotal']))  
    print('Free memory: {0}'.format(meminfo['MemFree']))
```
作用：读取 proc/meminfo 中的信息，Python 字符串的 split 方法是用的频率还是比较多的。比如我们需要存储一个很长的数据，并且按照有结构的方法存储，方便以后取数据进行处理。当然可以用 json 的形式。但是也可以把数据存储到一个字段里面，然后有某种标示符来分割。 Python 中的 strip 用于去除字符串的首位字符，最后打印出内存总数和空闲数。

可以使用 Python 命令运行脚本 mem.py 结果如下：
```
[root@node6 py]# python mem.py  
Total memory: 236380 kB  
Free memory: 84404 kB
```
## 对网络接口的监测

```
[root@node6 py]# cat net.py  
#!/usr/bin/python  
import time  
import sys
if len(sys.argv) > 1: 
    INTERFACE = sys.argv[1]  
else:  
    INTERFACE = 'eth0'  
STATS = []  
print 'Interface:',INTERFACE
def    rx(): 
    ifstat = open('/proc/net/dev').readlines()  
    for interface in  ifstat:  
        if INTERFACE in interface:  
            stat = float(interface.split()[1])  
            STATS[0:] = [stat]
def    tx(): 
    ifstat = open('/proc/net/dev').readlines()  
    for interface in  ifstat:  
        if INTERFACE in interface:  
            stat = float(interface.split()[9])  
            STATS[1:] = [stat]
print    'In        Out' 
rx()  
tx()
while    True: 
    time.sleep(1)  
    rxstat_o = list(STATS)  
    rx()  
    tx()  
    RX = float(STATS[0])  
    RX_O = rxstat_o[0]  
    TX = float(STATS[1])  
    TX_O = rxstat_o[1]  
    RX_RATE = round((RX - RX_O)/1024/1024,3)  
    TX_RATE = round((TX - TX_O)/1024/1024,3)  
    print RX_RATE ,'MB        ',TX_RATE ,'MB'
```
作用：读取/proc/net/dev 中的信息，Python 中文件操作可以通过 open 函数，这的确很像 C 语言中的 fopen。通过 open 函数获取一个 file object，然后调用 read()，write()等方法对文件进行读写操作。另外 Python 将文本文件的内容读入可以操作的字符串变量非常容易。文件对象提供了三个“读”方法： read()、readline() 和 readlines()。每种方法可以接受一个变量以限制每次读取的数据量，但它们通常不使用变量。 .read() 每次读取整个文件，它通常用于将文件内容放到一个字符串变量中。然而 .read() 生成文件内容最直接的字符串表示，但对于连续的面向行的处理，它却是不必要的，并且如果文件大于可用内存，则不可能实现这种处理。.readline() 和 .readlines() 之间的差异是后者一次读取整个文件，象 .read() 一样。.readlines() 自动将文件内容分析成一个行的列表，该列表可以由 Python 的 for ... in ... 结构进行处理。另一方面，.readline() 每次只读取一行，通常比 .readlines() 慢得多。仅当没有足够内存可以一次读取整个文件时，才应该使用 .readline()。最后打印出网络接口的输入和输出情况。

可以使用 Python 命令运行脚本 net.py 结果如下：
```
[root@node6 py]# python net.py  
Interface: eth0  
In        Out  
0.3 MB        0.1 MB  
0.4 MB        0.2 MB  
0.2 MB        0.1 MB  
0.6 MB        0.3 MB  
0.5 MB        0.2 MB  
0.9 MB        0.5 MB  
0.7 MB        0.3 MB
```

## 监控Apache服务器进程的Python脚本
```
[root@node6 py]# cat apache.py
#!/usr/bin/python
import os, sys, time
while True:
time.sleep(4)
try:
ret = os.popen('ps -C apache -o pid,cmd').readlines()
if len(ret) < 2:
print "apache 进程异常退出， 4 秒后重新启动"
time.sleep(3)
os.system("service apache2 restart")
except:
print "Error", sys.exc_info()[1]
```

设置文件权限为执行属性（使用命令 chmod +x apache.py），然后加入到/etc/rc.local 即可，一旦 Apache 服务器进程异常退出，该脚本自动检查并且重启。 简单说明一下脚本 5 这个脚本不是基于/proc 伪文件系统的，是基于 Python 自己提供的一些模块来实现的 。这里使用的是 Python 的内嵌 time 模板，time 模块提供各种操作时间的函数。