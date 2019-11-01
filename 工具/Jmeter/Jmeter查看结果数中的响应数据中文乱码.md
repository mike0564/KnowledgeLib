# Jmeter查看结果数中的响应数据中文乱码

当响应数据或响应页面没有设置编码时，jmeter会按照jmeter.properties文件中，sampleresult.default.encoding设置的格式解析
默认ISO-8859-1，解析中文肯定出错

\# The encoding to be used if none is provided (default ISO-8859-1)

\#sampleresult.default.encoding=ISO-8859-1

例如查看结果树中的中文为乱码，可以通过以下方式进行修改解决：

1.直接修改sampleresult.default.encoding=UTF-8。（记住去掉#，不要还是注释状态哦）

2.动态修改（这种方法方便些）

    step1：指定请求节点下，新建后置控制器"BeanShell PostProcessor"
    step2：其脚本框中输入：prev.setDataEncoding("UTF-8");
    step3：保存
