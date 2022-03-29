# Windows系统下TCP参数优化

通常会采用修改注册表的方式改进Windows的系统参数。

下面将为大家介绍Windows系统下的TCP参数优化方式，适用于Windows 2003、Windows XP、Windows 7以及Server版。

对于具体的系统环境与性能需求，优化方式会有所差异，效果也不尽相同，仅是个人的建议。所有的优化操作都通过修改注册表实现，需要使用regedit命令进入注册表并创建或修改参数，修改完成后需要重启系统，以使之生效。

以下使用的参数值均为10进制。

## 1. TCPWindowSize

**TCPWindowSize的值表示TCP的窗口大小。**

TCP Receive Window（TCP数据接收缓冲）定义了发送端在没有获得接收端的确认信息的状态下可以发送的最大字节数。此数值越大，返回的确认信息就越少，相应的在发送端和接收端之间的通信就越好。此数值较小时可以降低发送端在等待接收端返回确认信息时发生超时的可能性，但这将增加网络流量，降低有效吞吐率。TCP在发送端和接收端之间动态调整一个最大段长度MSS（Maximum Segment Size）的整数倍。MSS在连接开始建立时确定，由于TCP Receive Window被调整为MSS的整数倍，在数据传输中完全长度的TCP数据段的比例增加，故而提高了网络吞吐率。

缺省情况下，TCP将试图根据MSS来优化窗口大小，起始值为16KB，最大值为64KB。TCPWindowSize的最大值通常为65535字节（64KB），以太网最大段长度为1460字节，低于64KB的1460的最大整数倍为62420字节，因而可以在注册表中将TCPWindowSize设置为62420，作为高带宽网络中适用的性能优化值。

具体操作如下：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为TCPWindowSize的REG_DWORD值，该值的范围是从0到65535，将该值设置为62420。

## 2. TCP1323Opts

为了更高效地利用高带宽网络，可以使用比上述TCP窗口大得多的TCP窗口大小，此特性是Windows 2000和Windows Server 2003中的新特性，称为TCP Window Scaling，它将以前的65535字节（64KB）的限制提高到了1073741824字节（1GB）。在带宽与延迟的乘积值很高的连接上（例如卫星连接），可能需要将窗口的大小增加到64KB以上。使用TCP Window Scaling，系统可以允许确认信息间更大数据量的传输，增加了网络吞吐量及性能。发送端和接收端往返通信所需的时间被称为回环时间（RTT）。TCP Window Scaling仅在TCP连接的双方都开启时才真正有效。

TCP有一个时间戳选项，通过更加频繁地计算来提高RTT值的估测值，此选项特别有助于估测更长距离的广域网上连接的RTT值，并更加精确地调整TCP重发超时时间。时间戳在TCP报头提供了两个区域，一个记录开始重发的时间，另一个记录接收到的时间。时间戳对于TCP Window Scaling，即确认信息收到前的大数据包传送特别有用，激活时间戳仅仅在每个数据包的头部增加12字节，对网络流量的影响微乎其微。

数据完整性与数据吞吐率最大化哪个更为重要是个需要评估的问题。在某些环境中，例如视频流传输，需要更大的TCP窗口，这是最重要的，而数据完整性排在第二位。在这种环境中，TCP Window Scaling可以不打开时间戳。当发送端和接收端均激活TCP Window Scaling和时间戳时，此特性才有效。不过，若在发包时加入了时间戳，经过NAT之后，如果前面相同的端口被使用过，且时间戳大于这个连接发出的SYN中的时间戳，就会导致服务器忽略该SYN，表现为用户无法正常完成TCP的3次握手。初始时生成小的TCP窗口，之后窗口大小将按照内部算法增大。

具体操作如下：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为TCP1323Opts的REG_DWORD值，该值的具体含义为：0（缺省值）表示禁用TCP Window Scaling和时间戳；1表示只启用TCP Window Scaling；2表示只启用时间戳；3表示同时启用TCP Window Scaling和时间戳。TCP1323Opts设置为激活TCP Window Scaling后，可以将上文中的注册表项TCPWindowSize的值增大，最大能达到1GB，为了达到最佳性能，这里的值最好设置成MSS的倍数，推荐值为256960字节。

## 3. TCP 控制块表

**对于每个TCP连接，控制变量保存在一个称为TCP控制块（TCB）的内存块中。**

TCB表的大小由注册表项MaxHashTableSize控制。在活动连接很多的系统中，设定一个较大的表可以降低系统定位TCB表的时间。在TCB表上分区可以降低对表的访问的争夺。增加分区的数量，TCP的性能会得到优化，特别是在多处理器的系统上。注册表项NumTcbTablePartitions控制分区的数量，默认是处理器个数的平方。TCB通常预置在内存中，以防止TCP反复连接和断开时，TCB反复重新定位浪费时间，这种缓冲的方式促进了内存管理，但同时也限制了同一时刻允许的TCP连接数量。

注册表项MaxFreeTcbs决定了处于空闲等待状态的TCB重新可用之前的连接数量，在NT架构中常设置成高于默认值，以确保有足够的预置的TCB。从Windows 2000开始添加了一个新特性，降低超出预置TCB运行的可能性。如果处于等待状态的连接多于MaxFreeTWTcbs中的设置，所有等待时间超过60秒的连接将被强制关闭，以后再次启用。

此特性合并到Windows 2000 Server和Windows Server 2003后，MaxFreeTcbs将不再用于优化性能。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为MaxHashTableSize的REG_DWORD值，该值的范围是从1到65536，并且必须为2的N次方，缺省值为512，建议设为8192。然后在Parameters子键下创建或修改名为NumTcbTablePartitions的REG_DWORD值，该值的范围是从1到65536，并且必须为2的N次方，缺省值为处理器个数的平方，建议设为处理器核心数的4倍。

## 4. TcpTimedWaitDelay

**TcpTimedWaitDelay的值表示系统释放已关闭的TCP连接并复用其资源之前，必须等待的时间。**

这段时间间隔就是以前的Blog中提到的TIME_WAIT状态（2MSL，数据包最长生命周期的两倍状态）。如果系统显示大量连接处于TIME_WAIT状态，则会导致并发量与吞吐量的严重下降，通过减小该项的值，系统可以更快地释放已关闭的连接，从而为新连接提供更多的资源，特别是对于高并发短连接的Server具有积极的意义。

该项的缺省值是240，即等待4分钟后释放资源；系统支持的最小值为30，即等待时间为30秒。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为TcpTimedWaitDelay的REG_DWORD值，该值的范围是从0到300，建议将该值设置为30。

## 5. MaxUserPort

**MaxUserPort的值表示当应用程序向系统请求可用的端口时，TCP/IP可分配的最大端口号。**

如果系统显示建立连接时出现异常，那么有可能是由于匿名（临时）端口数不够导致的，特别是当系统打开大量端口来与Web service、数据库或其他远程资源建立连接时。

该项的缺省值是十进制的5000，这也是系统允许的最小值。Windows默认为匿名（临时）端口保留的端口号范围是从1024到5000。为了获得更高的并发量，建议将该值至少设为32768以上，甚至设为理论最大值65534，特别是对于模拟高并发测试环境的Client具有积极的意义。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为MaxUserPort的REG_DWORD值，该值的范围是从5000到65534，缺省值为5000，建议将该值设置为65534。

## 6. 动态储备

**动态储备的值使系统能自动调整其配置，以接受大量突发的连接请求。**

如果同时接收到大量连接请求，超出了系统的处理能力，那么动态储备就会自动增大系统支持的暂挂连接的数量（即Client已请求而Server尚未处理的等待连接数，TCP连接的总数包括已连接数与等待连接数），从而可减少连接失败的数量。系统的处理能力和支持的暂挂连接的数量不足时，Client的连接请求将直接被拒绝。

缺省情况下，Windows 不启用动态储备，可以通过以下操作进行开启和设置：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AFD\Parameters注册表子键，在Parameters子键下创建或修改下列名称的REG_DWORD值。
	• EnableDynamicBacklog，值为1，表示开启动态储备。
	• MinimumDynamicBacklog，值为128，表示支持的最小暂挂连接的数量为128。
	• MaximumDynamicBacklog，值为2048，表示支持的最大暂挂连接的数量为2048。对于高并发短连接的Server，建议最大值设为1024及以上。
	• DynamicBacklogGrowthDelta，值为128，表示支持的暂挂连接的数量的增量为128，即数量不足时自增长128，直到达到设定的最大值，如2048。

## 7. KeepAliveTime

**KeepAliveTime的值控制系统尝试验证空闲连接是否仍然完好的频率。**

如果该连接在一段时间内没有活动，那么系统会发送保持连接的信号，如果网络正常并且接收方是活动的，它就会响应。如果需要对丢失接收方的情况敏感，也就是说需要更快地发现是否丢失了接收方，请考虑减小该值。而如果长期不活动的空闲连接的出现次数较多，但丢失接收方的情况出现较少，那么可能需要增大该值以减少开销。

缺省情况下，如果空闲连接在7200000毫秒（2小时）内没有活动，系统就会发送保持连接的消息。 通常建议把该值设为1800000毫秒，从而丢失的连接会在30分钟内被检测到。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为KeepAliveTime的REG_DWORD值，为该值设置适当的毫秒数。

## 8. KeepAliveInterval

**KeepAliveInterval的值表示未收到另一方对“保持连接”信号的响应时，系统重复发送“保持连接”信号的频率。**

在无任何响应的情况下，连续发送“保持连接”信号的次数超过TcpMaxDataRetransmissions（下文将介绍）的值时，将放弃该连接。如果网络环境较差，允许较长的响应时间，则考虑增大该值以减少开销；如果需要尽快验证是否已丢失接收方，则考虑减小该值或TcpMaxDataRetransmissions值。

缺省情况下，在未收到响应而重新发送“保持连接”的信号之前，系统会等待1000毫秒（1秒），可以根据具体需求修改。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为KeepAliveInterval的REG_DWORD值，为该值设置适当的毫秒数。

## 9. TcpMaxDataRetransmissions

**TcpMaxDataRetransmissions的值表示TCP数据重发，系统在现有连接上对无应答的数据段进行重发的次数。**

如果网络环境很差，可能需要提高该值以保持有效的通信，确保接收方收到数据；如果网络环境很好，或者通常是由于丢失接收方而导致数据的丢失，那么可以减小该值以减少验证接收方是否丢失所花费的时间和开销。

缺省情况下，系统会重新发送未返回应答的数据段5次，可以根据具体需求修改。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为TcpMaxDataRetransmissions的REG_DWORD值，该值的范围是从0到4294967295，缺省值为5，根据实际情况进行设置。

## 10. TcpMaxConnectRetransmisstions

**TcpMaxConnectRetransmisstions的值表示TCP连接重发，TCP退出前重发非确认连接请求（SYN）的次数。**

对于每次尝试，重发超时是成功重发的两倍。在Windows Server 2003中默认超时次数是2，默认超时时间为3秒（在注册表项TCPInitialRTT中）。速度较慢的WAN连接中超时时间可相应增加，不同环境中可能会有不同的最优化设置，需要在实际环境中测试确定。超时时间不要设置太大否则将不会发生网络连接超时时间。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters注册表子键，在Parameters子键下创建或修改名为TcpMaxConnectRetransmisstions的REG_DWORD值，该值的范围是从0到255，缺省值为2，根据实际情况进行设置。然后在Parameters子键下创建或修改名为TCPInitialRTT的REG_DWORD值，同样根据实际情况进行设置。

## 11. TcpAckFrequency

**TcpAckFrequency的值表示系统发送应答消息的频率。**

如果值为2，那么系统将在接收到2个分段之后发送应答，或是在接收到1个分段但在200毫秒内没有接收到任何其他分段的情况下发送应答；如果值为3，那么系统将在接收到3个分段之后发送应答，或是在接收到1个或2个分段但在200毫秒内没有接收到任何其他分段的情况下发送应答，以此类推。如果要通过消除应答延迟来缩短响应时间，那么建议将该值设为1。在此情况下，系统会立即发送对每个分段的应答；如果连接主要用于传输大量数据，而200毫秒的延迟并不重要，那么可以减小该值以降低应答的开销。

缺省情况下，系统将该值设为2，即每隔一个分段应答一次。该值的有效范围是0到255，其中0表示使用缺省值2，可以根据具体需求修改。

具体操作：

浏览至HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP\Parameters\Interfaces\xx（xx由网络适配器决定）注册表子键，在xx子键下创建或修改名为TcpAckFrequency的REG_DWORD值，该值的范围是从1到13，缺省值为2，根据希望每发送几个分段返回一个应答而设置该值，建议百兆网络设为5，千兆网络设为13。
