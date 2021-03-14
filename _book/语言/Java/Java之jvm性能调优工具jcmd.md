# Java之jvm性能调优工具jcmd

## 概述

在JDK1.7以后，新增了一个命令行工具 jcmd。他是一个多功能的工具，可以用它来导出堆、查看Java进程、导出线程信息、执行GC、还可以进行采样分析（jmc 工具的飞行记录器）。

命令格式
- jcmd <pid | main class> <command ... | PerfCounter.print | -f  file>
- jcmd -l
- jcmd -h
## 描述
- pid：接收诊断命令请求的进程ID。

main class ：接收诊断命令请求的进程的main类。匹配进程时，main类名称中包含指定子字符串的任何进程均是匹配的。如果多个正在运行的Java进程共享同一个main类，诊断命令请求将会发送到所有的这些进程中。

- command：接收诊断命令请求的进程的main类。匹配进程时，main类名称中包含指定子字符串的任何进程均是匹配的。如果多个正在运行的Java进程共享同一个main类，诊断命令请求将会发送到所有的这些进程中。

Perfcounter.print：打印目标Java进程上可用的性能计数器。性能计数器的列表可能会随着Java进程的不同而产生变化。

- -f file：从文件file中读取命令，然后在目标Java进程上调用这些命令。在file中，每个命令必须写在单独的一行。以"#"开头的行会被忽略。当所有行的命令被调用完毕后，或者读取到含有stop关键字的命令，将会终止对file的处理。
- -l：查看所有的进程列表信息。
- -h：查看帮助信息。（同 -help）

注意: 如果任何参数含有空格，你必须使用英文的单引号或双引号将其包围起来。 此外，你必须使用转义字符来转移参数中的单引号或双引号，以阻止操作系统shell处理这些引用标记。当然，你也可以在参数两侧加上单引号，然后在参数内使用双引号(或者，在参数两侧加上双引号，在参数中使用单引号)。

查看进程 jcmd -l

命令：jcmd -l

描述：查看 当前机器上所有的 jvm 进程信息

- jcmd
- jcmd -l
- jps

这三个命令的效果是一样的

查看性能统计

命令：jcmd pid PerfCounter.print

描述：查看指定进程的性能统计信息。
```
C:\Windows\system32>jcmd 9592 PerfCounter.print
9592:
java.ci.totalTime=16704
java.cls.loadedClasses=438
java.cls.sharedLoadedClasses=0
java.cls.sharedUnloadedClasses=0
java.cls.unloadedClasses=0
java.property.java.class.path="D:\work\git\test\target\classes"
java.property.java.endorsed.dirs="D:\Program Files\Java\jre1.8.0_91\lib\endorsed"
java.property.java.ext.dirs="D:\Program Files\Java\jre1.8.0_91\lib\ext;C:\Windows\Sun\Java\lib\ext"
java.property.java.home="D:\Program Files\Java\jre1.8.0_91"
...
```
列出当前运行的 java 进程可以执行的操作

命令：jcmd PID help
```
C:\Windows\system32>jcmd 9592 help
9592:
The following commands are available:
JFR.stop
JFR.start
JFR.dump
JFR.check
VM.native_memory
VM.check_commercial_features
VM.unlock_commercial_features
ManagementAgent.stop
ManagementAgent.start_local
ManagementAgent.start
GC.rotate_log
Thread.print
GC.class_stats
GC.class_histogram
GC.heap_dump
GC.run_finalization
GC.run
VM.uptime
VM.flags
VM.system_properties
VM.command_line
VM.version
help
```
查看具体命令的选项

如果想查看命令的选项，比如想查看 JFR.dump 命令选项，可以通过如下命令:

jcmd 11772 help JFR.dump

### JRF 相关命令
JRF 功能跟 jmc.exe 工具的飞行记录器的功能一样的。

要使用 JRF 相关的功能，必须使用 VM.unlock_commercial_features 参数取消锁定商业功能 。

jmc.exe 显示的提示

#### 启动JFR
执行命令：jcmd $PID JFR.start name=abc,duration=120s
#### Dump JFR
等待至少duration（本文设定120s）后，执行命令：jcmd PID JFR.dump name=abc,duration=120s filename=abc.jfr（注意，文件名必须为.jfr后缀）
#### 检查JFR状态
执行命令：jcmd $PID JFR.check name=abc,duration=120s
#### 停止JFR
执行命令：jcmd $PID JFR.stop name=abc,duration=120s
#### JMC分析
切回开发机器，下载步骤3中生成的abc.jfr，打开jmc，导入abc.jfr即可进行可视化分析

### VM.uptime
命令：jcmd PID VM.uptime
描述：查看 JVM 的启动时长：

### GC.class_histogram
命令：jcmd PID GC.class_histogram
描述：查看系统中类统计信息
这里和jmap -histo pid的效果是一样的
这个可以查看每个类的实例数量和占用空间大小。

### Thread.print
命令：jcmd PID Thread.print
描述：查看线程堆栈信息。
该命令同 jstack命令。

### GC.heap_dump
命令：jcmd PID GC.heap_dump FILE_NAME
描述：查看 JVM 的Heap Dump
```
C:\Users\jjs>jcmd 10576 GC.heap_dump d:\dump.hprof
10576:
Heap dump file created
```

跟 jmap命令：jmap -dump:format=b,file=heapdump.phrof pid 效果一样。

导出的 dump 文件，可以使用MAT 或者 Visual VM 等工具进行分析。

注意：如果只指定文件名，默认会生成在启动 JVM 的目录里。

### VM.system_properties
命令：jcmd PID VM.system_properties
描述：查看 JVM 的属性信息
```
C:\Users\jjs>jcmd 10576 VM.system_properties
10576:
#Wed Jan 31 22:30:20 CST 2018
java.vendor=Oracle Corporation
osgi.bundles.defaultStartLevel=4
......
os.version=10.0
osgi.arch=x86_64
path.separator=;
java.vm.version=25.91-b15
org.osgi.supports.framework.fragment=true
user.variant=
osgi.framework.shape=jar
java.awt.printerjob=sun.awt.windows.WPrinterJob
osgi.instance.area.default=file\:/C\:/Users/jjs/eclipse-workspace/
sun.io.unicode.encoding=UnicodeLittle
org.osgi.framework.version=1.8.0
......
```
### VM.flags
命令：jcmd PID VM.flags
描述：查看 JVM 的启动参数
```
C:\Users\jjs>jcmd 10576 VM.flags
10576:
-XX:CICompilerCount=3 -XX:ConcGCThreads=1 
-XX:G1HeapRegionSize=1048576 -XX:InitialHeapSize=268435456 
-XX:MarkStackSize=4194304 -XX:MaxHeapSize=1073741824 
-XX:MaxNewSize=643825664 -XX:MinHeapDeltaBytes=1048576 
-XX:+UseCompressedClassPointers -XX:+UseCompressedOops 
-XX:+UseFastUnorderedTimeStamps -XX:+UseG1GC 
-XX:-UseLargePagesIndividualAllocation -XX:+UseStringDeduplication
```
### VM.command_line
命令：jcmd PID VM.command_line
描述：查看 JVM 的启动命令行
```
C:\Users\jjs>jcmd 10576 VM.command_line
10576:
VM Arguments:
jvm_args: -Dosgi.requiredJavaVersion=1.8 
-Dosgi.instance.area.default=@user.home/eclipse-workspace 
-XX:+UseG1GC -XX:+UseStringDeduplication 
-Dosgi.requiredJavaVersion=1.8 -Xms256m -Xmx1024m
java_command: <unknown>
java_class_path (initial): D:\tool\...\org.eclipse.equinox.launcher.jar
```
### GC.run_finalization
命令：jcmd PID GC.run_finalization
描述： 对 JVM 执行 java.lang.System.runFinalization()
```
C:\Users\jjs>jcmd 10576 GC.run_finalization
10576:
Command executed successfully
```
执行一次finalization操作，相当于执行java.lang.System.runFinalization()
### GC.run
命令：jcmd PID GC.run
描述：对 JVM 执行 java.lang.System.gc()
```
C:\Users\jjs>jcmd 10576 GC.run
10576:
Command executed successfully
```
告诉垃圾收集器打算进行垃圾收集，而垃圾收集器进不进行收集是不确定的。
### PerfCounter.print
命令：jcmd PID PerfCounter.print
描述：查看 JVM 性能相关的参数
```
C:\Users\jjs>jcmd 10576 PerfCounter.print
10576:
java.ci.totalTime=93024843
java.cls.loadedClasses=18042
java.cls.sharedLoadedClasses=0
java.cls.sharedUnloadedClasses=0
java.cls.unloadedClasses=3
......
```
### VM.version
命令：jcmd PID VM.version
描述：查看目标jvm进程的版本信息
```
C:\Users\jjs>jcmd 10576 VM.version
10576:
Java HotSpot(TM) 64-Bit Server VM version 25.91-b15
JDK 8.0_91
```