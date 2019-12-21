# Jmeter参数变量中包含引号导致异常

在使用"${变量名}"时，由于变量中包含双引号，导致异常。

![](./images/jmeter_09_01.png)
![](./images/jmeter_09_02.png)
![](./images/jmeter_09_03.png)

解决办法：

使用vars.get("变量名");进行调用

![](./images/jmeter_09_04.png)