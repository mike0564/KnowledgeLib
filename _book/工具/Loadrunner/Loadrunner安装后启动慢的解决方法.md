# Loadrunner安装后启动慢的解决方法

目录：

C:\Windows\Microsoft.NET\Framework\v2.0.50727\CONFIG

文件名：machine.config

修改runtime：

增加以下内容：
```
<runtime>
     <generatePublisherEvidence enabled="false"/>
</runtime>
```
