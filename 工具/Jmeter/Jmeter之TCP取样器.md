# Jmeter之TCP取样器

如果"Re-use connection"(重复使用连接) 复选框被选中了，在同一个线程中Samplers(取样器)共享连接，包含相同主机名和端口，不同主机/端口合并将会使用不同线程。如果"Re-use connection"和 "Close connection"(关闭连接)同时被选中，这个套接字在运行完当前Samplers将会关闭。再下一个Sampler将会另外创建一个新套接字。你可能想要在每次线程循环结束之后关闭套接字。

如果一个错误被检测到或者"Re-use connection”"没有被选中，这个套接字将会关闭，另外套接字将会在接下Samplers被再一次打开。

接下的属性将会应用到控制操作的行为

tcp.status.prefix：用文本来表示前缀的状态数字

tcp.status.suffix：用文本来表示后缀的状态数字

tcp.status.properties：用属性文件名称去将状态码转成消息

tcp.handler：表示处理请求的实现类（默认是TCPClientImpl）-也就是TCPClient classname 这行你没有填写任何东西

这个处理器请求的类已经在GUI配置了，tcp.handler设置的类无效，如果没有找到，它就会去org.apache.jmeter.protocol.tcp.sampler包下找

用户可以提供他自己的实现类，这个类必须要继承org.apache.jmeter.protocol.tcp.sampler.TCPClient父类

下面是就JMeter已经提供的实现类：

- TCPClientImpl
- BinaryTCPClientImpl
- LengthPrefixedBinaryTCPClientImpl

这些实现类有如下的行为：

TCPClientImpl

这是最简单的实现类，如果你设置属性tcp.eolByte的话，它将读取一行字节作为响应，其他的情况是通过读取流的方式，你可以采用平台默认字符编码或者你通过设置属性tcp.charset来设置你想要的编码。

BinaryTCPClientImpl

这个实现类能够转换界面输入字符串为二进制，但是必须是16进制的字符串，读取响应的时候反过来。当读取响应的时候，它会读取到设置属性tcp.BinaryTCPClient.eomByte结束符，否则读取到输入流的末尾。

LengthPrefixedBinaryTCPClientImpl

这个实现类继承BinaryTCPClientImpl，它在BinaryTCPClientImpl前面增加数据长度，它默认有两个字节，当然你也可以通过属性tcp.binarylength.prefix.length进行设置

超时处理：

如果你设置超时，读取流在超时之后会终止，所以当你在使用eolByte/eomByte 确保超时时间设置足够长，否则读取流过早终止。

响应处理：

如果tcp.status.prefix 被定义了，那么它会自动搜索前缀和后缀包裹的文本信息，如果发现了这样信息，它将被用来设置响应码。然而响应信息可以根据响应码从属性文件中读取（如果你提供了属性文件的话）。



<table border="1" width="800" cellspacing="1" cellpadding="1"><caption>参数解释</caption><tbody><tr><td>属性</td><td>描述</td><td>必要？</td></tr><tr><td>Name</td><td>展示在右侧树形列表的名称</td><td>默认就有</td></tr><tr><td>TCPClient classname</td><td>表示处理请求的实现类，默认是TCPClientImpl ,对应属性设置名为tcp.handler</td><td>不是</td></tr><tr><td>ServerName or IP Port Number</td><td>服务器 主机名，ip地址 端口号</td><td>是</td></tr><tr><td>Re-use connection</td><td>如果选中，这个链接处于保持打开状态，不选中就是读取数据后就关闭</td><td>是</td></tr><tr><td>Close connection</td><td>如果选中，这个链接将会在运行中取样器之后被关闭</td><td>是</td></tr><tr><td>SO_LINGER</td><td>enable/disable（启用/禁用）SO_LINGER设置特定的值，单位为秒，它线性创建套接字，如果你是设置的值为0，你可以避免大量套接字处于TIME_WAIT （等待状态）</td><td>不是</td></tr><tr><td>End of line (EOL) by value</td><td>表示一行结束符，如果设置值在-128到127之外将会跳过eol 检查，你可以在jmeter.properties文件中增加属性eolByte进行设置，如果你在TCP Sampler Config(TCP 取样器配置)中也设置这个属性，那么TCP Sampler Config 中设置的将会奏效</td><td>不是</td></tr><tr><td>Connect TimeOUt</td><td>连接超时（单位毫秒，0 表示禁用超时）</td><td>不是</td></tr><tr><td>Response Timeout</td><td>连接超时（单位毫秒，0 表示禁用超时）</td><td>不是</td></tr><tr><td>Set NoDelay</td><td>可以参考java.net.Socket.setTcpNoDelay()，如果选中，它将会禁用Nagle's算法（利用缓存功能），反之</td><td>是</td></tr><tr><td>Text to Send</td><td>&nbsp;发送文本信息</td><td>是</td></tr><tr><td>Login User</td><td>用户名-它不会使用默认实现</td><td>不是</td></tr><tr><td>Password</td><td>密码-它不会使用默认实现，（N.B.【note well 注意】它在测试计划中采用非加密存储 ）</td><td>不是</td></tr></tbody></table>

## 配置项介绍
1 、TCPClient classname TCP报文格式（有三类）
默认前缀:org.apache.jmeter.protocol.tcp.sampler
- TCPClientImpl:普通文本传输，可设置编码格式(eg：json串)
- BinaryTCPClientImpl:十六进制报文（常用）
- LengthPrefixedBinaryTCPClientImpl 继承BinaryTCPClientImpl类，并在BinaryTCPClientlmpl前面增加两个字节长度

2 、Target Server【IP和端口】

3 、Timeouts【最大超时时间】

4 、Re-use connection【TCP长连接】

5 、End ofline(EOL) byte value  响应数据的最后2位，转换为10进制的值。取值区间[-128,127]

因为TCP长连接不会主动断开，所以我们需要从响应数据来判断并告知TCP取样器这次请求已经拿到了数据，然后再运行其他线程。

例如：响应数据为“F000”，最后2位是“00”，所以这里填入“0”。如果不知道返回数据，可以调测。因为没有设置EOL，所以在运行后，自行点击stop。然后在“查看结果树”的响应数据中查看数据。

如果这个长连接确实没有数据返回，那需要找开发给个返回值

6 、要发送的文本【需要开发提供】

7、编码格式
- tcp.handler=TCPClientImpl
- tcp.handler=BinaryTCPClientImpl
- tcp.handler=LengthPrefixedBinaryTCPClientImpl

8、注意事项
十六进制数之间不能有空格，否则报错
Response message:java.lang.IllegalArgumentException: Hex-encoded binary string contains anuneven no. of digits）
不能有换行，否则报错：
Response message:java.lang.IllegalArgumentException: Hex-encoded binary string contains anuneven no. of digits）