# Windows中bat脚本延时执行

在批处理中，经常需要用到“延时（等待）”，那么如何让批处理延时呢？

## [方法1]

在windows vista及以上系统中，系统提供了一个“timeout”命令。优点：方便，一行命令搞定。缺点：不能在旧系统中（例如xp）使用，且延时精度较低（1秒）。
```
TIMEOUT [/T] timeout [/NOBREAK]
```
描述:

这个工具接受超时参数，等候一段指定的时间(秒)或等按任意键。它还接受一个参数，忽视按键。

参数列表:
```
/T timeout 指定等候的秒数。有效范围从 -1 到 99999 秒。不能使用表达式例如 60*5之类的。
/NOBREAK 忽略按键并等待指定的时间。
/? 显示此帮助消息。
```
注意: 超时值 -1 表示无限期地等待按键。
```
::等待10秒，并且可以按任意键跳过等待
TIMEOUT /T 10
::等待300秒，并且只能按下CTRL+C来跳过
TIMEOUT /T 300 /NOBREAK
::持续等待，直到按下任意按键.功能类似于pause
TIMEOUT /T -1
::持续等待，直到按下CTRL+C按键
TIMEOUT /T -1 /NOBREAK
```

## [方法2]

使用vbs的sleep方法来实现延时（等待）。优点：能在旧系统中（例如xp）使用，且延时精度较高（1毫秒）缺点：代码行数较多，3行。
```
echo CreateObject("Scripting.FileSystemObject").DeleteFile(WScript.ScriptFullName) >%Temp%\Wait.vbs
echo wscript.sleep ▲ >>%Temp%\Wait.vbs
start /wait %Temp%\Wait.vbs
```
注意：其中的“▲”为等待的毫秒数，1秒=1000毫秒，等待10000毫秒，即10秒。

当然，也可以使用并行符号“&”，把命令并成一行
```
echo createobject("scripting.filesystemobject").deletefile(wscript.scriptfullname) >%temp%\VBScriptWait.vbs& echo wscript.sleep ▲ >>%temp%\VBScriptWait.vbs& start /wait %temp%\VBScriptWait.vbs
```