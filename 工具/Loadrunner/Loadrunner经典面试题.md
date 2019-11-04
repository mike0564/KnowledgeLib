# Loadrunner经典面试题

## 在LoadRunner中为什么要设置思考时间和pacing 

答： 录制时记录的是客户端和服务端的交互，如果要精确模拟用户的行为，那么客户操作客户端时花费了很多时间要怎么模拟呢?录入填写提交的内容，从列表中下拉搜索选择特定的值等，这时LOADRUNNER不会记录用户的客户端操作，而是记录了用户这段时间，成为思考时间(Think-time)，因为用户的这些客户端操作不会影响服务端，只是让服务器端在这段时间内没有请求而已。所以加入思考时间就能模拟出熟练的或者生疏的用户操作，接近实际对于服务端的压力。Vuser思考时间模拟实际用户在不同操作之间等待的时间。例如，当用户收到来自服务器的数据时，可能要等待几秒钟查看数据，然后再做出响应。这种延迟就称为“思考时间”。VuGen使用lr_think_time函数将思考时间值录制到 Vuser 脚本中。以下录制的函数指明用户等待了8秒钟才执行下一个操作：

`lr_think_time(8);`

当您运行了Vuser脚本并且Vuser遇到了上述lr_think_time语句时，默认情况下，Vuser将等待8秒钟后再执行下一个操作。可以使用思考时间运行时设置来影响运行脚本时Vuser使用录制思考时间的方式。

## 如何理解TPS? 

答：TPS主要还是体现服务器对当前录制的事务的处理速度快慢。TPS高并不代表性能好。

TPS 是Transactions Per Second的缩写，也就是事务数/秒。它是软件测试结果的测量单位。一个事务是指一个客户机向服务器发送请求然后服务器做出反应的过程。客户机在发送请求时开始计时，收到服务器响应后结束计时，以此来计算使用的时间和完成的事务个数，最终利用这些信息来估计得分。客户机使用加权协函数平均方法来计算客户机的得分，软件就是利用客户机的这些信息使用加权协函 数平均方法来计算服务器端的整体TPS得分。

## 如何使用loadrunner批量添加树型结构数据 
```
/*此段代码为:添加”树状”节点数据，代码源于*****项目，此码仅添加数据到第三层。*/
/*前置条件:用户已登录并具有操作权限*/
/*思路:新增一级节点–>获取一级ID–>添加二级节点–>展开一级节点–>获取二级ID–>添加三级数据*/
/*说明：添加一级节点–>逐个读取一级节点ID–>读到一个一级节点就给它添加二级节点–>
二级节点添加完一次就读一次ID–>读一次二级节点直接添加三级节点*/
/*修改”树状”节点数据的代码类似，Submit修改时，要多建一个参数TreeCode*/
int i,j,k,p; //循环变量
int No1,No2,No3; //分别保存一、二、三级节点的个数
int M1,M2,M3; //分别定义一、二级节点的数量，三级节点不保存数据，故未限制大小
char *MyID1[90],*MyID2[90],m[40]; //MyID1用于储存所有一级节点数据，m为临时数组变量
/* MyID的长度也大于M的长度；m的长度要大于ID的长度+1 */
M1=30;M2=20;M3=10;
/*RootID名称需要按模块修改，Control里需要重新参数化*/
lr_save_string (“FindRootIDinWebResource”,”RootID”);//根节点的ID,修改此处即可使用
lr_output_message (“当前根节点的ID号为:%s”,lr_eval_string (“{RootID}”));
for (i=1;i<=M1 ;i++ ) //添加M1个一级节点
{
lr_save_int(i,"L");
//#########添加一级节点
web_submit_data("{RootID}{L}");
} lr_output_message ("已添加%d个一级节点",M1);
web_reg_save_param("IDS", //获取一级节点ID
"LB=value=\"",
"RB=\"",
"ORD=All",
LAST);
//#######展开根节点
web_url("{RootID}");
No1=atoi(lr_eval_string ("{IDS_count}")); //获取ID的数量，保存在变更No1中
lr_output_message ("获取一级节点的数量为: %d",No1);
if (No1>M1) { No1=M1;}//让No1<=M1
for (i=1;i<=No1;i++) //将一级节点的ID写入MyID1中
{
sprintf(m,"{IDS_%d}",i); //生成动态字符串{IDS_i}，存在变量m中************核心步骤
MyID1[i-1]=lr_eval_string (m); //读取{IDS_i}参数对应的值，保存到MyID1中****核心步骤
lr_output_message ("一级节点第%d共%d,m=%s即MyID1[%d]=,%s",i,No1,m,i-1,MyID1[i-1]);
lr_save_string (MyID1[i-1],"SubID");//将MyID1转换为参数{SubID}以便使用
for (j=1;j<=M2;j++ )//添加M2个二级节点
{
lr_save_int(j,"M");
//#######添加下级节点
web_submit_data("{RootID}{SubID}{M}");
} lr_output_message ("已添加%d个二级节点",M2);
web_reg_save_param("IDS2", //获取二级节点ID
"LB=value=\"",
"RB=\"",
"ORD=All",
LAST);
//########展开选中节点
web_url("{RootID}{SubID}");
No2=atoi(lr_eval_string ("{IDS2_count}")); //获取ID的数量，保存在变更No2中
lr_output_message ("获取二级节点的数量为: %d",No2);
if (No2>M2) { No2=M2;}//让No2<=M2
for (k=1;k<=No2;k++) //将二级节点的ID写入MyID2中
{
sprintf(m,”{IDS2_%d}”,k); //生成动态字符串{IDS2_i}，存在变量m中************核心步骤
MyID2[k-1]=lr_eval_string (m); //读取{IDS2_i}参数对应的值，保存到MyID2中****核心步骤
lr_output_message (“开始处理@二级节点:第%d共%d,m=%s即MyID1[%d]=,%s”,k,No2,m,k-1,MyID2[k-1]);
lr_save_string (MyID2[k-1],”SubID2″);//将MyID1转换为参数{SubID}以便使用
lr_save_int(k,”N”);
for (p=1;p<=M3;p++) //添加子节点
{
lr_save_int(p,”P”);
//########添加三级节点
web_submit_data(“{RootID}{SubID}{P}”);
}lr_output_message (“当前状态@一级节点%d,二级节点%d：已添加%d个三级节点”,i,k,M3);
}
}
```

## loadrunner对应用程序性能分析的总结 

一个应用程序是由很多个组件组成的，整个应用程序的性能好不好需要从整体入手去分析。

打开analysis页面，将左下角的display only graphs containing data 置为不选，然后选中web page breakdown ，点击“open graph”添加需要分析的功能项。

web page breakdown中显示的是每个页面的下载时间。点选左下角web page breakdown 展开,可以看到每个页中包括的css 样式表，js 脚本，jsp 页面等所有的属性。

在select page to breakdown 中选择页面。选中后，在选择栏下方看到属于它的组件。哪一行的事物占据的时间较长，那么它的消耗时间点就在这里，分析问题也就要从这里入手。

对相应的组件所标注的颜色分析如下：

### 1、dns resolution 

显示使用最近的dns服务器，将dns解析为ip地址所需要的时间，“dns查找”度量是指示dns解析问题或dns服务器问题的一个很好的指示器。

### 2、connection

显示与包含指定的URL的web服务器建立初始连接所需要的时间。连接度量是一个很好的网络问题指示器。另外，他还能判断服务器是否对请求作出响应。

### 3、first buffer

显示从初始HTTP请求（通常为get） 到成功收到来自web服务器的第一次缓冲时为止所经过的时间。第一次缓冲度量可以判断是否存在web服务器延迟或者网络滞后。

注意点：由于缓冲区最大为8k，因此第一次缓冲时间可能也就是完成元素下载所需要的时间。

### 4、ssl handshaking

显示建立ssl连接（包括客户端请求，服务器请求，客户端公用密钥传输，服务器证书传输及其它部分可选阶段）所用的时间。自此点之后，客户端及服务器之间所有的通信都将被加密。

注意点：ssl握手度量仅适用用https通信。

### 5、receive

显示从服务器收到最后一个字节，并完成下载之前所经过的时间。

接收度量可以查看网络质量，查看用来计算接收速率的时间/大小比率。

### 6、ftp authentication

显示验证客户端所用的时间。如果使用ftp，则服务器在开始处理客户端命令之前，必须验证该客户端。、

此功能只是用与使用ftp通信。

### 7、client

显示因浏览器思考时间或其它与客户端有关的延迟而使客户机上的请求发生延迟时，所经过的平均时间。

### 8、error

显示从发出HTTP请求到返回错误消息（仅限于HTTP错误）期间所经过的平均时间。

分析以上指标，结合系统资源监控指标，会比较准确快速的定位问题。从而对系统的性能及随后的调优提供针对性的意见。

## 使用LoadRunner进行性能测试的一般步骤是什么？ 

-  确定需要进行测试的业务或交易，通过手工操作和Vuser Generator的录制功能来记录并生成虚拟用户脚本。
-  手工修改虚拟用户脚本，确定脚本能够成功回放。
-  在Controller中对场景进行配置后，启动测试。在测试过程中，Controller控制Load Generator对被测系统的加压方式和行为。
-  Controller同时负责搜集被测系统各个环节的性能数据。各个Loaded Generator会记录最终用户响应时间和脚本执行的日志。
-  压力运行结束后，Loaded Generaror将数据传输到Controller中，有Controller对测试结果进行汇总。
-  借助数据分析工具Analysis对性能测试数据进行分析，确定瓶颈和调优方法。
-  对系统进行针对性的调优，重复进行压力测试，确定性能是否有所提高。

## loadrunner中的设置线程和进程的区别 

loadrunner中，在进行运行设置中有一项选择，是按进程运行Vuser或按线程运行Vuser?下面进行分别来讲：

- 1.按进程运行Vuser：Controller将使用驱动程序mdrv运行Vuser。如果按进程方式运行每个Vuser，则对于每个Vuser实例，都将启动一个mdrv进程。如果设置了10个Vuser，则在任务管理器中出现10个mdrv进程。多个mdrv进程肯定会占用大量内存及其他系统资源，这就限制了可以在任一负载生成器上运行的Vuser的数量。

- 2.按线程运行Vuser:及设置了10个Vuser，其只会调用一个驱动程序mdrv.而每个Vuser都按线程运行，这些线程Vuser将共享父进程的内存段。这就节省了大量内存控件，从而可以在一个负载生成器上运行更多的Vuser。

任何选择都是有两面性的。选择线程方式运行Vuser会带来一些安全问题。因为线程的资源是从进程资源中分配出来的，因此同一个进程中的多个线程会有共享的内存空间，这样可能会引起多个线程的同步问题，调度不好，就会出问题，不如A线程要用的资源就必须等待B线程释放，而B也在等待其他资源释放才能继续。这就会出现这样的问题：同一个测试场景，用线程并发就会超时失败或报错，而用进程并发就没错。

虽然会有区别，但两种方式的运行都会给服务端造成的压力是一样的。

## 如何用loadrunner录制sql server测试一个sql语句或存储过程的执行 

本次通过loadRunner录制SQL Server介绍一下如何测试一个sql语句或存储过程的执行性能。

主要分如下几个步骤完成：
- 第一步、测试准备
- 第二步、配置ODBC数据源
- 第三步、录制SQL语句在Sql Server查询分析器中的运行过程
- 第四步、优化录制脚本，设置事务
- 第五步、改变查询数量级查看SQL语句的性能
- 第六步、在controller中运行脚本

下面开始具体的介绍：

测试准备阶段我们首先要确认测试数据库服务器：我们可以在本地安装SQL SERVER数据库服务端及客户端，也可以确定一台装好的SQL SERVER服务器。

接下来，准备测试数据：对数据库测试时我们要考虑的不是SQL语句是否能够正确执行，而是在某数量级的情况下SQL语句的执行效率及数据库服务的运行情况，所以我们分别准备不同数量级的测试数据，即根据实际的业务情况预估数据库中的记录数，在本次讲解中我们不考虑业务逻辑也不考虑数据表之间的关系，我们只建立一张表，并向此表中加入不同数量级的数据，如分别加入1000条、10000条、50000条、100000条数据查看某SQL语句的执行效率。

在查询分析器中运行如下脚本：
```
--创建测试数据库
create database loadrunner_test;
use loadrunner_test
--创建测试数据表
create table test_table
(username varchar(50),sex int,age int,address varchar(100),post int)
--通过一段程序插入不同数量级的记录，具体的语法在这里就不多说了
declare @i int
set @i=0
while @i<1000 //循环1000次，可以根据测试数据情况改变插入条数
begin
BEGIN TRAN T1
insert into test_table (username,sex,age,address,post) values ('户瑞海'+cast(@i as varchar),@i-1,@i+1,'北京市和平里'+cast(@i as varchar)+'号',123456);
IF @@ERROR <> 0
begin
rollback;
select @@error
end
else
begin
commit;
set @i = @i+1
end
end
```

好了，执行完上述语句后，建立的数据表中已经有1000条记录了，下面进行第二步的操作，配置ODBC数据源，为了能让loadrunner能够通过ODBC协议连接到我们建立的SQL SERVER数据路，我们需要在本机上建立ODBC数据源，建立方法如下：

控制面板—性能和维护—管理工具—数据源（ODBC）--添加，在列表中选择SQL SERVER点击完成，根据向导输入数据源名称，链接的服务器，下一步，输入链接数据库的用户名和密码，更改链接的数据库，完成ODBC的配置，如果配置正确的话，在最后一步点击“测试数据源”，会弹出测试成功的提示。

配置好ODBC数据源后就要录制SQL语句在查询分析器中的执行过程了：

- 1、 打开loadrunner，选择ODBC协议
- 2、 在start recording中的application type 选择win32 application；program to record中录入SQL SERVER查询分析器的路径“..\安装目录\isqlw.exe”
- 3、 开始录制，首先通过查询分析器登录SQL SERVER，在打开的查询分析器窗口中输入要测试的SQL语句，如“select * from test_table;”
- 4、 在查询分析器中执行该语句，执行完成后，结束录制

好了，现在就可以看到loadrunner生成的脚本了，通过这些语句，我们可以看出，登录数据库的过程、执行SQL语句的过程。

接下来，我们来优化脚本，我们分别为数据库登录部分和执行SQL语句的部分加一个事物，在增加一个double的变量获取事务执行时间，简单内容如下：

```
Action()
{ double trans_time; //定义一个double型变量用来保存事务执行时间
lr_start_transaction("sqserver_login"); //设置登录事务的开始
lrd_init(&InitInfo, DBTypeVersion); //初始化链接（下面的都是loadrunner生成的脚本了，大家可以通过帮助查到每个函数的意思）
lrd_open_context(&Ctx1, LRD_DBTYPE_ODBC, 0, 0, 0);
lrd_db_option(Ctx1, OT_ODBC_OV_ODBC3, 0, 0);
lrd_alloc_connection(&Con1, LRD_DBTYPE_ODBC, Ctx1, 0 /*Unused*/, 0);
………………
trans_time=lr_get_transaction_duration( "sqserver_login" ); //获得登录数据库的时间
lr_output_message("sqserver_login事务耗时 %f 秒", trans_time); //输出该时间
lr_end_transaction("sqserver_login", LR_AUTO); //结束登录事务
lr_start_transaction("start_select");//开始查询事务
lrd_cancel(0, Csr2, 0 /*Unused*/, 0);
lrd_stmt(Csr2, "select * from test_table;\r\n", -1, 1, 0 /*None*/, 0);//此句为执行的SQL
lrd_bind_cols(Csr2, BCInfo_D42, 0);
lrd_fetch(Csr2, -10, 1, 0, PrintRow24, 0);
……………..
trans_time=lr_get_transaction_duration( "start_select" ); //获得该SQL的执行时间
lr_output_message("start_select事务耗时 %f 秒", trans_time); //输出该时间
lr_end_transaction("start_select", LR_AUTO); //结束查询事务
```

优化后，在执行上述脚本后，就可以得到登录到数据库的时间及运行select * from test_table这条语句的时间了，当然我们也可以根据实际情况对该条语句进行参数化，可以测试多条语句的执行时间，也可以将该语句改为调用存储过程的语句来测试存储过程的运行时间。

接下来把该脚本在controller中运行，设置虚拟用户数，设置集合点，这些操作我就不说了，但是值得注意的是，没有Mercury 授权的SQL SERVER用户license，在运行该脚本时回报错，提示“You do not have a license for this Vuser type.

最起码在VUGen中运行该脚本我们可以得到任意一个SQL语句及存储过程的执行时间，如果我们测试的B/S结构的程序

## 如何完全卸载LoadRunner? 

- 1.首先保证所有LoadRunner的相关进程（包括Controller、VuGen、Analysis和Agent Process）全部关闭。
- 2.备份好LoadRunner安装目录下测试脚本，一般存放在LoadRunner安装目录下的“scrīpts”子目录里。
- 3.在控制面板的“删除与添加程序”中运行LoadRunner的卸载程序。如果弹出提示信息关于共享文件的，都选择全部删除。
- 4.卸载向导完成后，重新启动电脑。完成整个LoadRunner卸载过程。
- 5.删除整个LoadRunner目录。（包括Agent Process）
- 6.在操作中查找下列文件，并且删除它们（如果有）
    1） wlrun.*
    2） vugen.*7.运行注册表程序（开始－ 运行－ regedit）8.删除下列键值：

如果只安装了MI公司的LoadRunner这一个产品，请删除：
```
HKEY_LOCAL_MACHINESOFTWAREMercury Interactive.
HKEY_CURRENT_USERSOFTWAREMercury Interactive.
```
否则请删除：
```
HKEY_LOCAL_MACHINESOFTWAREMercury InteractiveLoadRunner.
HKEY_CURRENT_USERSOFTWAREMercury InteractiveLoadRunner.
```

- 9.最后清空回收站

完成了以上操作就可以正常的重新安装LoadRunner。安装LoadRunner时最好关闭所有的杀毒程序。

## loadrunner如何遍历一个页面中的url并进行访问？ 

代码如下：

```
Action()
{
char temp[64];
int num = 0 ;
int i = 0 ;
char *str ;
// char *temp ;
//获取函数，是一个数组
web_reg_save_param(
“UrlList”,
“LB/ALNUMIC=<a href=\”",
“RB=\”",
“ORD=all”,
LAST);
web_url(“localhost”,
“URL=http://www.baidu.com”,
LAST);
//获取数据的长度
str = lr_eval_string(“{UrlList_count}”);
lr_error_message(“%s”,str);
num = atoi(str);
for(i=1;i<=num;i++){
//格式化输出
sprintf(temp,”{UrlList_%d}”,i);
//生成参数
lr_save_string(lr_eval_string(temp),”Turl”);
//判定URL 是否合法
if (strstr(lr_eval_string(temp),”http”)) {
web_url(“TESTER”,”URL={Turl}”, LAST);
}else
{
lr_error_message(“Url is not exits”);
}
}
return 0;
}
```

## LoadRunner分析实例面试题 

### 1.Error: Failed to connect to server “172.17.7.230″: [10060] Connection
### Error: timed out Error: Server “172.17.7.230″ has shut down the connection prematurely

分析：

- A、应用服务死掉。

(小用户时：程序上的问题。程序上处理数据库的问题，实际测试中多半是服务器链接的配置问题)

- B、应用服务没有死

(应用服务参数设置问题)

对应的Apache和tomcat的最大链接数需要修改，如果连接时收到connection refused消息，说明应提高相应的服务器最大连接的设置，增加幅度要根据实际情况和服务器硬件的情况来定，建议每次增加25%!

- C、数据库的连接

(数据库启动的最大连接数(跟硬件的内存有关))

- D、我们的应用程序spring控制的最大链接数太低

### 性能调优的基本原则是什么？ 

如果某个部分不是瓶颈，就不要试图优化。

优化是为系统提供足够的资源并且充分的利用资源，而不是无节制的扩充资源。

优化有时候也意味着合理的分配或划分任务。

优化可能会过头，注意协调整个系统的性能。

### LoadRunner如何插入Text/Image 检查点 ？ 

在进行压力测试时，为了检查Web 服务器返回的网页是否正确，这些检查点验证网页上是否存在指定的Text 或者Image，还可以测试在比较大的压力测试环境中，被测的网站功能是否保持正确。

操作步骤:
- 1、可以将视图切换到TreeView 视图
- 2、在树形菜单中选择需要插入检查点的一项，然后点鼠标右键，选择将检查点插到该操作执行前(Insert Before)还是执行后(Insert After)。
- 3、在弹出对话框中选择web Checks 下面的Image Check 或是 Text Check
- 4、对需要检查点设置相关的属性

### LoadRunner如何从现有数据库中导入数据 

通过 LoadRunner，可以从数据库中导入数据以用于参数化。您可以用下列两种方法中的一种导入数据：

- 1.新建查询
- 2.指定 SQL 语句

VuGen 提供一个指导您完成从数据库中导入数据的过程的向导。在该向导中，您可以指定如何导入数据（通过 MS Query 新建查询或者指定 SQL 语句）。

导入数据之后，它被另存为一个扩展名为.dat 的文件，并且存储为常规参数文件。

### LoadRunner如何模拟用户思考时间？ 

- 1. 用户在执行两个连续操作期间等待的时间称为“思考时间”。
- 2. Vuser 使用lr_think_time 函数模拟用户思考时间。录制 Vuser 脚本时，VuGen 将录制实际的思考时间并将相应的 lr_think_time 语句插入到 Vuser 脚本。
- 3. 可以编辑已录制的 lr_think_time 语句，也可在 脚本中手动添加更多lr_think_time 语句。
- 4. 以秒为单位指定所需的思考时间

LoadRunner脚本中如何插入集合点(Rendezvous) 

插入集合点(Rendezvous)

集合点：如果脚本中设置集合点，可以达到绝对的并发，但是集合点并不是并发用户的代名词，设置结合点和不设置结合点，需要看你站在什么角度上来看待并发，是整个服务器，还是提供服务的一个事务；

- 1.插入集合点是为了衡量在加重负载的情况下服务器的性能情况。
- 2.在测试计划中，可能会要求系统能够承受1000 人甚至更多同时提交数据，在LR 中可以通过在提交数据操作前面加入集合点，当虚拟用户运行到提交数据的集合点时，LR 就会检查同时有多少用户运行到集合点，从而达到测试计划中的需求。
- 3.Rendezvous，也可在录制时按插入集合点按钮?具体的操作方法如下：在需要插入集合点的前面，点击菜单Insert

注意：集合点经常和事务结合起来使用。集合点只能插入到Action 部分，vuser_init和vuser_end 中不能插入集合点。

### LoadRunner如何插入事务(Transaction) ？ 

- 1. 事务为衡量服务器的性能，需要定义事务。
- 2. LoadRunner 运行到该事务的开始点时，LR就会开始计时，直到运行到该事务的结束点，这个事务的运行时间在结果中会有反映。
- 3. 插入事务操作可以在录制过程中进行，也可以在录制结束后进行。LR 运行在脚本中插入不限数量的事务。
- 4. 在菜单中单击Insert Transaction后，输入事务名称，也可在录制过程中进行，在需要定义事务的操作后面插入事务的“结束点”。默认情况下，事务的名称列出最近的一个事务名称。一般情况下，事务名称不用修改。事务的状态默认情况下是LR_AUTO。一般情况下，我们也不需要修改状态的

### LoadRunner如何创建脚本？ 

- 1. 启动VuGen:选择需要新建的协议脚本，可以创建单协议，或是多协议脚本
- 2. 点击Start Record按钮，输入程序地址，开始进行录制
- 3. 使用VuGen进行录制：创建的每个 Vuser 脚本都至少包含三部分：vuser_init、一个或多个 Actions 及vuser_end。录制期间，可以选择脚本中 VuGen 要插入已录制函数的部分。运行多次迭代的Vuser 脚本时，只有脚本的Actions部分重复，而vuser_init和vuser_end部分将不重复

### HTML-Based scrīpt 和URL-Based scrīpt 录制的区别？ 

- 1.基于浏览器的应用程序推荐使用HTML-Based scrīpt。
- 2.不是基于浏览器的应用程序推荐使用URL-Based scrīpt。
- 3.如果基于浏览器的应用程序中包含了Java scrīpt并且该脚本 向服务器产生了请求，比如DataGrid的分页按钮等，也要使用URL-Based scrīpt方式录制。
- 4.基于浏览器的应用程序中使用了HTTPS安全协议，使用URL-Based scrīpt方式录制。
- 5.录制过程中不要使用浏览器的“后退”功能，LoadRunner对其支持不太好。

### LoadRunner如何设置Recording Options 选项？（以单协议http/html为例） 
- 1.菜单tools->Recording Options进入录制的设置窗体
- 2.Recording标签页:选用哪种录制方式
- 3.Browser标签页：浏览器的选择
- 4.Recording Proxy 标签页：浏览器上的代理设置
- 5.Advanced 标签页：可以设置录制时的think time，支持的字符集标准等
- 6.Correlation标签页：手工设置关联，通过关联可在测试执行过程中保存动态值。使用这些设置可以配置 VuGen 在录制过程中执行的自动关联的程度。

### LoadRunner如何选择协议？ 

很多人使用loadrunner录制脚本时都得不到理想的结果，出现这种情况大多是由于录制脚本时选择了不当的协议。那我们在录制脚本前如何选择合适的通信协议呢？用单协议还是双协议？

LoadRunner属于应用在客户端的测试工具，在客户端模拟大量并发用户去访问服务器，从而达到给服务器施加压力的目的。所以说LoadRunner模拟的就是客户端，其脚本代表的是客户端用户所进行的业务操作，即只要脚本能表示用户的业务操作就可以。

- 1.LR支持多种协议，请大家一定要注意，这个地方协议指的是你的Client端通过什么协议访问的Server，Client一般是面向最终使用者的，Server是第一层Server端，因为现在的体系架构中经常Server层也分多个层次，什么应用层，什么数据层等等，LR只管Client如何访问第一层Server.
- 2.特别要注意某些应用，例如一个Web系统，这个系统是通过ActiveX控件来访问后台的，IE只是一个容器，而ActiveX控件访问后台是通过COM/DCOM协议的，这种情况就不能使用Web协议，否则你什么也录制不到，所以，LR工程师一定要了解应用程序的架构和使用的技术。
- 3. 如HTTPS，一般来讲一定要选择多协议，但在选择具体协议的时候一定只选Web协议，这时候才能作那个端口映射。

通常协议选择

- 1.对于常见的B/S系统，选择Web(Http/Html)
- 2.测一个C/S系统，根据C/S结构所用到的后台数据库来选择不同的协议，如果后台数据库是sybase，则采用sybaseCTlib协议，如果是SQL server,则使用MS SQL server的协议，至于oracle 数据库系统，当然就使用Oracle 2-tier协议。
- 3.对于没有数据库的C/S（ftp,smtp）这些可以选择Windwos Sockets协议。
- 4.至于其他的ERP，EJB（需要ejbdetector.jar），选择相应的协议即可.
- 5. 一般可以使用Java vuser协议录制由java编写的C/S模式的软件, ,当其他协议都没有用时,只能使用winsocket协议

### Loadrunner支持哪些常用协议？ 

- 1.Web(HTTP/HTML)
- 2.Sockets
- 3..net 协议
- 4.web services
- 5.常用数据库协议（ODBC，ORACLE，SQLSERVER 等）
- 6.邮件(SMTP、pop3)
- 7.其它协议

### 性能测试的类型都有哪些？ 

#### 负载测试(Load Test)

通过逐步增加系统负载，测试系统性能的变化，并最终确定在满足性能指标的情况下，系统所能承受的最大负载量的测试。

#### 压力测试(Stress Test)

通过逐步增加系统负载，测试系统性能的变化，并最终确定在什么负载条件下系统性能处于失效状态，并以此来获得系统能够提供的最大服务级别的测试。

压力测试是一种特定类型的负载测试。

#### 疲劳强度测试

通常是采用系统稳定运行情况下能够支持的最大并发用户数或者日常运行用户数，持续执行一段时间业务，通过综合分析交易执行指标和资源监控指标来确定系统处理最大工作量强度性能的过程。

疲劳强度测试可以反映出系统的性能问题，例如内存泄漏等。

#### 大容量测试(Volume Test)

对特定存储、传输、统计、查询业务的测试。

### 并发用户数是什么？跟在线用户数什么关系？ 

并发主要是针对服务器而言，是否并发的关键是看用户操作是否对服务器产生了影响。因此，并发用户数量的正确理解为：在同一时刻与服务器进行了交互的在线用户数量，这种交互既可以是单向的传输数据，也可以是双向的传送数据。

- 1.并发用户数是指系统运行期间同一时刻进行业务操作的用户数量。
- 2.该数量取决于用户操作习惯、业务操作间隔和单笔交易的响应时间。
- 3.使用频率较低的应用系统并发用户数一般为在线用户数的5%左右。
- 4.使用频率较高的应用系统并发用户数一般为主线用户数的10%左右

### Loadrunner常用的分析点都有哪些？ 

#### Vusers：

提供了生产负载的虚拟用户运行状态的相关信息，可以帮助我们了解负载生成的结果。

#### Rendezvous（负载过程中集合点下的虚拟用户）：

当设置集合点后会生成相关数据，反映了随着时间的推移各个时间点上并发用户的数目，方便我们了解并发用户的变化情况。

#### Errors（错误统计）：

通过错误信息可以了解错误产生的时间和错误类型，方便定位产生错误的原因。

#### Errors per Second（每秒错误）：

了解在每个时间点上错误产生的数目，数值越小越好。通过统计数据可以了解错误随负载的变化情况，定为何时系统在负载下开始不稳定甚至出错。

#### Average Transaction Response Time（平均事务响应时间）：

反映随着时间的变化事务响应时间的变化情况，时间越小说明处理的速度越快。如果和用户负载生成图合并，就可以发现用户负载增加对系统事务响应时间的影响规律。

#### Transactions per Second（每秒事务）：

TPS吞吐量，反映了系统在同一时间内能处理事务的最大能力，这个数据越高，说明系统处理能力越强。

#### Transactions Summary（事务概要说明）

统计事物的Pass数和Fail数，了解负载的事务完成情况。通过的事务数越多，说明系统的处理能力越强；失败的事务数越小说明系统越可靠。

#### Transaction performance Summary(事务性能概要)：

事务的平均时间、最大时间、最小时间柱状图，方便分析事务响应时间的情况。柱状图的落差越小说明响应时间的波动小，如果落差很大，说明系统不够稳定。

#### Transaction Response Time Under Load（用户负载下事务响应时间）：

负载用户增长的过程中响应时间的变化情况，该图的线条越平稳，说明系统越稳定。

#### Transactions Response time(事务响应时间百分比)：

不同百分比下的事务响应时间范围，可以了解有多少比例的事物发生在某个时间内，也可以发现响应时间的分布规律，数据越平稳说明响应时间变化越小。

#### Transaction Response Time（各时间段上的事务数）：

每个时间段上的事务个数，响应时间较小的分类下的是无数越多越好。

#### Hits per Second（每秒点击）：

当前负载重对系统所产生的点击量记录，每一次点击相当于对服务器发出了一次请求，数据越大越好。

#### Throughput（吞吐量）：

系统负载下所使用的带宽，该数据越小说明系统的带宽依赖就越小，通过这个数据可以确定是不是网络出现了瓶颈。

#### HTTP Responses per Second（每秒HTTP响应）：

每秒服务器返回各种状态的数目，一般和每秒点击量相同。点击量是客户端发出的请求数，而HTTP响应数是服务器返回的响应数。如果服务器的响应数小于点击量，那么说明服务器无法应答超出负载的连接请求。

#### Connections per Second（每秒连接）：

统计终端的连接和新建的连接数，方便了解每秒对服务器产生连接的数量。同时连接数越多，说明服务器的连接池越大，当连接数随着负载上升而停止时，说明系统的连接池已满，通常这时候服务器会返回504错误。需要修改服务器的最大连接来解决该问题。

### LoadRunner不执行检查方法怎么解决？ 

在录制Web协议脚本中添加了检查方法Web_find，但是在脚本回放的过程中并没有执行。

错误现象：在脚本中插入函数Web_find，在脚本中设置文本以及图像的检查点，但是在回放过程中并没有对设置的检查点进行检查，即Web_find失效。

错误分析：由于检查功能会消耗一定的资源，因此LoadRunner默认关闭了对文本以及图像的检查，所以在设置检查点后，需要开启检查功能。

解决办法：打开运行环境设置对话框进行设置，在“Run-time Settings”的“Internet Protocol”选项里的“Perference”中勾选“Check”下的“Enable Image and text check”选项。

### LoadRunner请求无法找到如何解决？ 

在录制Web协议脚本回放脚本的过程中，会出现请求无法找到的现象，而导致脚本运行停止。

错误现象：Action.c(41): Error -27979: Requested form. not found [MsgId: MERR-27979]
```
Action.c(41): web_submit_form. highest severity level was “ERROR”,0 body bytes, 0 header bytes [MsgId: MMSG-27178]”
```
这时在tree view中看不到此组件的相关URL。

错误分析：所选择的录制脚本模式不正确，通常情况下，基于浏览器的Web应用会使用“HTML-based script”模式来录制脚本；而没有基于浏览器的Web应用、Web应用中包含了与服务器进行交互的Java Applet、基于浏览器的应用中包含了向服务器进行通信的JavaScript/VBScript代码、基于浏览器的应用中使用HTTPS安全协议，这时则使用“URL-based script”模式进行录制。

解决办法：打开录制选项配置对话框进行设置，在“Recording Options”的“Internet Protocol”选项里的“Recording”中选择“Recording Level”为“HTML-based script”，单击“HTML Advanced”，选择“Script. Type”为“A script. containing explicit”。然后再选择使用“URL-based script”模式来录制脚本。

### LoadRunner HTTP服务器状态代码都有哪些？如何解决？ 

在录制Web协议脚本回放脚本的过程中，会出现HTTP服务器状态代码，例如常见的页面-404错误提示、-500错误提示。

#### 错误现象1：-404 Not Found服务器没有找到与请求URI相符的资源，但还可以继续运行直到结束。

错误分析：此处与请求URI相符的资源在录制脚本时已经被提交过一次，回放时不可再重复提交同样的资源，而需要更改提交资源的内容，每次回放一次脚本都要改变提交的数据，保证模拟实际环境，造成一定的负载压力。

解决办法：在出现错误的位置进行脚本关联，在必要时插入相应的函数。

#### 错误现象2：-500 Internal Server Error服务器内部错误，脚本运行停止。

错误分析：服务器碰到了意外情况，使其无法继续回应请求。

解决办法：出现此错误是致命的，说明问题很严重，需要从问题的出现位置进行检查，此时需要此程序的开发人员配合来解决，而且产生的原因根据实际情况来定，测试人员无法单独解决问题，而且应该尽快解决，以便于后面的测试。

#### 这两天测试并发修改采购收货时，录制回放正确，运行脚本，集合点3个并发时，却老是出错

如下：
```
Action.c(30): Error -26612: HTTP Status-Code=500 (Internal Server Error) forhttp://192.168.100.88:88/Purchase/stockin_action.asp?Oper=Edt

```
解决过程：按Help提示在浏览器输入原地址，发现提示“请重新登陆系统”。

被此误导，偶以为是Session ID、或Cookie失效，于是尝试找关联，花了N多时间。可是脚本里确实不存在需要关联的地方呀，系统默认关联了。

与程序员沟通，证实此过程不会涉及到Session ID 或Cookie。那为什么？

因为集合点下一站就是修改的提交操作，于是查找web_submit_data–>定位查找Log文档

注意点：怎么找log文件

–>Controller–>Results–>Results Settings 查找本次log文件保存目录–>到该目录下查找log文件夹–>打开

惊喜的发现其中竟然有所有Vuser 的运行log。–>打开Error 查找报错的Vuser–>打开相应的log文件

查找error，然后偶发现了一段让偶热泪盈眶的话：
```
Action.c(30):     <p>Microsoft OLE DB Provider for ODBC Drivers</font> <font face=”宋体” size=2>错误 ’800040
Action.c(30):     05′</font>\n
Action.c(30):     <p>\n
Action.c(30):     <font face=”宋体” size=2>[Microsoft][ODBC SQL Server Driver][SQL Server]事务（进程 ID  53）
Action.c(30):     与另一个进程已被死锁在  lock 资源上，且该事务已被选作死锁牺牲品。请重新运行该事务。</font>
Action.c(30):     \n
Action.c(30):     <p>\n
Action.c(30):     <font face=”宋体” size=2>/Purchase/stockin_action.asp</font><font face=”宋体” size=2>，行
Action.c(30):     205</font>
Action.c(30): Error -26612: HTTP Status-Code=500 (Internal Server Error) for “http://192.168.100.88:88/Purchase/stockin_action.asp?Oper=Edt”   [MsgId: MERR-26612]
Action.c(30): t=37758ms: Closing connection to 192.168.100.88 after receiving status code 500   [MsgId: MMSG-26000]
Action.c(30): t=37758ms: Closed connection to 192.168.100.88:88 after completing 43 requests   [MsgId: MMSG-26000]
Action.c(30): t=37760ms: Request done “http://192.168.100.88:88/Purchase/stockin_action.asp?Oper=Edt”   [MsgId: MMSG-26000]
Action.c(30): web_submit_data(“stockin_action.asp”) highest severity level was “ERROR”, 1050 body bytes, 196 header bytes   [MsgId: MMSG-26388]
Ending action Action. [MsgId: MMSG-15918]
Ending iteration 1. [MsgId: MMSG-15965]
Ending Vuser… [MsgId: MMSG-15966]
Starting action vuser_end. [MsgId: MMSG-15919]
```

解决了。。。。。。。

很寒。由此可以看出，查看日志文件是件多么重要的事情啊！！！！！

其实并发死锁本来就是本次的重点，之前是写事务，但没有做整个页面的锁定，只是写在SQL里。程序员说这样容易出现页面错误，

又改成页面锁定，具体怎么锁偶没看懂asp外行。之前事务冲突，偶让他写个标志，定义个数值字段增一，偶就可以直观看出来了。

这次改成页面就删掉这些标志了，于是出错就无处可寻。

这次最大的收获就是知道怎么查找Controller的log文件。以后看到Error就不会被牵着鼻子走了~~~~

### LoadRunner脚本中出现乱码如何解决？ 

在录制Web协议脚本时出现中文乱码，在回放脚本时会使回放停止在乱码位置，脚本无法运行。

错误现象：某个链接或者图片名称为中文乱码，脚本运行无法通过。

错误分析：脚本录制可能采用的是URL-based script方式，如果程序定义的字符集合采用的是国际标准，脚本就会出现乱码现象。

解决办法：重新录制脚本，在录制脚本前，打开录制选项配置对话框进行设置，在“Recording Options”的“Advanced”选项里先将“Surport Charset”选中，然后选中支持“UTF-8”的选项。

### LoadRunner超时错误如何解决？ 

在录制Web协议脚本回放时超时情况经常出现，产生错误的原因也有很多，解决的方法也不同。

#### 错误现象1：Action.c(16): Error -27728: Step download timeout (120 seconds) has expired when downloading non-resource(s)。

错误分析：对于HTTP协议，默认的超时时间是120秒（可以在LoadRunner中修改），客户端发送一个请求到服务器端，如果超过120秒服务器端还没有返回结果，则出现超时错误。

解决办法：首先在运行环境中对超时进行设置，默认的超时时间可以设置长一些，再设置多次迭代运行，如果还有超时现象，需要在“Runtime Setting”>“Internet Protocol：Preferences”>“Advanced”区域中设置一个“winlnet replay instead of sockets”选项，再回放是否成功。

#### 错误现象2：Action.c(81):Continuing after Error -27498: Timed out while processing URL=http://172.18.20.70:7001/workflow/bjtel/leasedline/ querystat/ subOrderQuery.do

错误分析：这种错误常常是因为并发压力过大，服务器端太繁忙，无法及时响应客户端的请求而造成的，所以这个错误是正常现象，是压力过大造成的。

如果压力很小就出现这个问题，可能是脚本某个地方有错误，要仔细查看脚本，提示的错误信息会定位某个具体问题发生的位置。

解决办法：例如上面的错误现象问题定位在某个URL上，需要再次运行一下场景，同时在其他机器上访问此URL。如果不能访问或时间过长，可能是服务器或者此应用不能支撑如此之大的负载。分析一下服务器，最好对其性能进行优化。

如果再次运行场景后还有超时现象，就要在各种图形中分析一下原因，例如可以查看是否服务器、DNS、网络等方面存在问题。

最后，增加一下运行时的超时设置，在“Run-Time Settings”>“Internet Protocol:Preferences”中，单击“options”，增加“HTTP-request connect timeout”或者“HTTP-request receive”的值。

### Error -27257: Pending web_reg_save_param/reg_find/create_html_param如何解决？ 

问题描述Error -27257: Pending web_reg_save_param/reg_find/create_html_param[_ex] request(s) detected and reset at the end of iteration number 1

解决方法：web_reg_save_param位置放错了，应该放到请求页面前面。

Failed to transmit data to network: [10057]Socket is not connected什么错误？ 

这个错误是由网络原因造成的，PC1和PC2上面都装了相同的loadrunner 9.0，且以相同数量的虚拟用户数运行相同的业务（机器上的其他条件都相同），PC1上面有少部分用户报错，PC2上的用户全部执行通过。

### Overlapped transmission of request to … WSA_IO_PENDING错误如何解决？ 

这个问题，解决方法：

- 1、方法一，在脚本前加入web_set_sockets_option(“OVERLAPPED_SEND”, “0″)，禁用TTFB细分，问题即可解决，但是TTFB细分图将不能再使用，附图。
- 2、方法二，可以通过增加连接池和应用系统的内存，每次增加25%。

### Failed to connect to server错误是什么原因？ 

这个问题一般是客户端链接到服务失败，原因有两个客户端连接限制（也就是压力负载机器），一个网络延迟严重，解决办法：

- 1、修改负载机器注册表中的TcpTimedWaitDelay减小延时和MaxUserPort增加端口数。注：这将增加机器的负荷。
- 2、检查网络延迟情况，看问题出在什么环节。

建议为了减少这种情况，办法一最好测试前就完成了，保证干净的网络环境，每个负载机器的压力测试用户数不易过大，尽量平均每台负载器的用户数，这样以上问题出现的概率就很小了。

### has shut down the connection prematurely什么错误？ 

一般是在访问应用服务器时出现，大用户量和小用户量均会出现。

来自网上的解释：

- 1>应用访问死掉

小用户时：程序上的问题。程序上存在数据库的问题

- 2>应用服务没有死

应用服务参数设置问题

例如：

在许多客户端连接Weblogic应用服务器被拒绝，而在服务器端没有错误显示，则有可能是Weblogic中的server元素的AcceptBacklog属性值设得过低。如果连接时收到connection refused消息，说明应提高该值，每次增加25％Java连接池的大小设置，或JVM的设置等

- 3>数据库的连接

在应用服务的性能参数可能太小了

数据库启动的最大连接数（跟硬件的内存有关）

以上信息有一定的参考价值，实际情况可以参考此类调试。

如果是以上所说的小用户时：程序上的问题。程序上存在数据库的问题，那就必须采用更加专业的工具来抓取出现问题的程序，主要是程序中执行效率很低的sql语句，weblogic可以采用introscope定位，期间可以注意观察一下jvm的垃圾回收情况看是否正常，我在实践中并发500用户和600用户时曾出现过jvm锯齿型的变化，上升下降都很快，这应该是不太正常的。

*实际测试中，可以用telent站点看看是否可以连接进去，可以通过修改连接池中的连接数和适当增加应用内存值，问题可以解决。*

### LoadRunner出现open many files错误是什么原因？ 

问题一般都在压力较大的时候出现，由于服务器或者应用中间件本身对于打开的文件数有最大值限制造成，解决办法：

- 1、修改操作系统的文件数限制，aix下面修改limits下的nofiles限制条件，增大或者设置为没有限制，尽量对涉及到的服务器都作修改。
- 2、方法一解决不了情况下再去查看应用服务器weblogic的commonEnv.sh文件，修改其中的nofiles文件max-nofiles数增大，应该就可以通过了，具体就是查找到nofiles方法，修改其中else条件的执行体，把文件打开数调大。修改前记住备份此文件，防止修改出错。
- 3、linux上可以通过ulimit –HSn 4096来修改文件打开数限制，也可以通过ulimit -a来查看。
- 4、linux上可以通过lsof -p pid | wc -l来查看进程打开的句柄数。

### connection refused是什么原因？ 

这个的错误的原因比较复杂，也可能很简单也可能需要查看好几个地方，解决起来不同的操作系统方式也不同。

- 1、首先检查是不是连接weblogic服务过大部分被拒绝，需要监控weblogic的连接等待情况，此时需要增加acceptBacklog，每次增加25%来提高看是否解决，同时还需要增加连接池和调整执行线程数，（连接池数*Statement Cache Size）的值应该小于等于oracle数据库连接数最大值。
- 2、如果方法一操作后没有变化，此时需要去查看服务器操作系统中是否对连接数做了限制，AIX下可以直接vi文件limits修改其中的连接限制数、端口数，还有tcp连接等待时间间隔大小，wiodows类似，只不过windows修改注册表，具体修改注册表中有TcpTimedWaitDelay和MaxUserPort项，键值在[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\]。因为负载生成器的性能太好，发数据包特别快，服务器也响应特别快，从而导致负载生成器的机器的端口在没有timeout之前就全部占满了。在全部占满后，就会出现上面的错误。执行netstat –na命令，可以看到打开了很多端口。所以就调整TCP的time out。即在最后一个端口还没有用到时，前面已经有端口在释放了。
        a,这里的TcpTimedWaitDelay默认值应该中是30s，所以这里，把这个值调小为5s（按需要调整）。
        b,也可以把MaxUserPort调大（如果这个值不是最大值的话）。

### Loadrunner出现 Connection reset by peer.是什么原因？ 

这个问题不多遇见，一般是由于下载的速度慢，导致超时，所以，需要调整一下超时时间。

解决办法：Run-time setting窗口中的‘Internet Protocol’－‘Preferences’设置set advanced options（设置高级选项），重新设置一下“HTTP-request connect timeout（sec），可以稍微设大一些”。

### Step download timeout (120 seconds)是什么问题？ 

这是一个经常会遇到的问题，解决得办法走以下步骤：
- 1、修改run time setting中的请求超时时间，增加到600s,其中有三项的参数可以一次都修改了，HTTP-request connect timeout，HTTP-request receieve timeout，Step download timeout，分别建议修改为600、600、5000。run time setting设置完了后记住还需要在control组件的option的run time setting中设置相应的参数。
- 2、办法一不能解决的情况下，解决办法如下：
        设置runt time setting中的internet protocol-preferences中的advaced区域有一个winlnet replay instead of sockets选项，选项后再回放就成功了。切记此法只对windows系统起作用

## Loadrunner相关问题 

### 1,action和init、end除了迭代的区别还有其他吗？

在init、end 中不能使用集合点、事务等。

### 2,HTTP的超时有哪三种？

HTTP-request connect timeout、HTTP-request receive timeout、step download timeout

### 3,在什么地方设置HTTP页面filter?

在runtime_settings中download filter里面进行设置。

### 4,pot mapping的原理是什么？

就是代理服务器

### 5,如何设置可以让一个虚拟IP对应到一个Vuser?

利用线程和进程做中介，逻辑上的对应。

选中Expert Mode，设置Options中的General

### 6,什么是contentcheck?如何来用？

ContentCheck的设置是为了让VuGen 检测何种页面为错误页面。如果被测的Web 应用没有使用自定义的错误页面，那么这里不用作更改；如果被测的Web 应用使用了自定义的错误页面，那么这里需要定义，以便让VuGen 在运行过程中检测，服务器返回的页面是否包含预定义的字符串，进而判断该页面是否为错误页面。如果是，VuGen就停止运行，指示运行失败。

使用方法：点击在runtime settings中点击“contentcheck”，然后新建立一个符合要求的应用程序和规则，设定需要查找的文本和前缀后缀即可使用。

### 7,network中的speed simulation是模拟的什么带宽？

模拟用户访问速度的带宽。

### 8,进程和线程有什么区别？

进程和线程的区别网上很多，不作过多讨论，重点说一下其在LR中选择的区别。最显著的区别是：线程有自己的全局数据。线程存在于进程中,因此一个进程的全局变量由所有的线程共享。由于线程共享同样的系统区域,操作系统分配给一个进程的资源对该进程的所有线程都是可用的,正如全局数据可供所有线程使用一样。在Controller中将使用驱动程序（如mdrv.exe、r3vuser.exe）运行vuser。如果按进程运行每个vuser，则对于每个vuser实例，都将反复启动同一驱动程序并将其加载到内存中。将同一驱动程序加载到内存中会占用大量的RAM（随机存储器）及其他系统资源。这就限制了可以在任一负载生成器上运行的vuser数量。如果按线程运行每个vuser，Controller为每50个vuser（默认情况下）仅启动驱动程序（如mdrv.exe）的一个实例。该驱动程序将启动几个vuser，每个vuser都按线程运行。这些线程vuser将共享父驱动进程的内存段。这就消除了多次重新加载驱动程序/进程的需要，节省了大量内存空间，从而可以在一个负载生成器上运行更多的Vuser。

### 9,生成WEB性能图有什么意义？大概描述即可。

可以很直观的看到，在负载下系统的运行情况以及各种资源的使用情况，可以对系统的性能瓶颈定位、性能调优等起到想要的辅助作用。

### 10,如何刷新controller里的脚本？

在controller中，点击detailis－Refresh-script即可。

### 11,WAN emulation是模拟什么的？

答：是模拟广域网环境的。模拟大量网络基础架构的行为。可以设置突出 WAN 效果的参数（如延迟、丢包、动态路由效果和链接故障），并监控模拟设置对网络性能的影响。

### 12,如何把脚本和结果放到load generator的机器上？

在controller中，点击Results-Results settings,在里面进行相应的设置即可。

### 13,如何设置才能让集合点只对一半的用户生效？

对集合点策略进行相应的设置即可。即在controller中，点击Scenario－Rendezvous-policy进行相应的设置即可，由于题目中“一半的用户”没有说明白具体指什么样的用户，现在不好确定具体对里面的哪个选项进行设置。

### 14,在设置windows资源图监控的时候，用到的是什么端口和协议？在这一过程中，会有大概哪些问题？（大概描述）

这个比较容易看吧，连上去，netstat -nao就可以看了

microsoft-ds ：445 ；要有权限、开启服务。

### LR中的API分为几类？ 
- Ａ：通用的ＡＰＩ：，就是跟具体的协议无关，在任何协议的脚本里都能用的；
- Ｂ：针对协议的：像lrs前缀是winsock的；lrd的是针对database;
- Ｃ：自定义的：这个范围就比较广了；
比如至少有Java Vuser API 、lrapi、XML API。还可以添加WindowsAPI和自定义函数库。

### 树视图和脚本视图各有什么优点？ 

Tree View的好处是使用户更方便地修改脚本，Tree View支持拖拽，用户可以把任意一个节点拖拽到他想要的地方，从而达到修改脚本的目的。用户可以右键单击节点，进行修改/删除当前函数参数属性，增加函数等操作，通过Tree View能够增加LoadRunner提供的部分常用通用函数和协议相关函数。

Script View适合一些高级用户，在Script View中能够看到一行行的API函数，通过Script View向脚本中增加一些其他API函数，对会编程的高手来说很方便

### LR的协议包分为多少类？ 

协议包不是指vuser类型。打开ＬＲ后，在选择vuser类型时，我们一般选择的上面一个下拉框都是all protocol。那个就是我说的协议包。

应用程序部署解决方案：Citrix ICA。

客户端/服务器：DB2 CLI、DNS、Informix、MS SQL Server、ODBC、Oracle（2层）、Sybase Ctlib、Sybase Dblib和Windows Sockets协议。

自定义：C模板、Visual Basic模板、Java模板、JavaScript和VBScript类型的脚本。

分布式组件：适用于COM/DCOM、Corba-Java和Rmi-Java协议。

电子商务：FTP、LDAP、Palm、PeopleSoft 8 mulit-lingual、SOAP、Web（HTTP/HTML）和双Web/WinSocket协议。

Enterprise Java Bean：EJB测试和Rmi-Java协议。

ERP/CRM：Baan、Oracle NCA、PeopleSoft-Tuxedo、SAP-Web、SAPGUI、

Siebel-DB2 CLI、Siebel-MSSQL、Siebel-Web和Siebel-Oracle协议。

传统：终端仿真（RTE）。

邮件服务：Internet邮件访问协议（IMAP）、MS Exchange（MAPI）、POP3和SMTP。

中间件：Jacada和Tuxedo（6、7）协议。

流数据：Media Player（MMS）和Real协议。

无线：i-Mode、VoiceXML和WAP协议。

### 需要关联的数据怎么确定？ 
- （１）通过LR自动关联来确定。
- （２）通过手动关联，查找服务器返回的动态数据，利用关联函数来确定。
- （３）对录制好的脚本，通过“scan action for correlations或CTRL+F8”来进行扫描查找需要关联的数据
- （４）如果知道需要做关联数据的左右边界等信息，可以自己添加相应的关联的规则来录制脚本，从而确定需要关联的数据。

### 场景设置有哪几种方法？ 

性能测试用例设计首先要分析出用户现实中的典型场景，然后参照典型场景进行设计。下面详细介绍一下常见的三类用户场景：

一天内不同时间段的使用场景。在同一天内，大多数系统的使用情况都会随着时间发生变化。例如对于新浪、网易等门户网站，在周一到周五早上刚一上班时，可能邮件系统用户比较多，而上班前或者中午休息时间则浏览新闻的用户较多；而对于一般的OA系统则早上阅读公告的较多，其他时间可能很多人没有使用系统或者仅有少量的秘书或领导在起草和审批公文。这类场景分析的任务是找出对系统产生压力较大的场景进行测试。

系统运行不同时期的场景。系统运行不同时期的场景是大数据量性能测试用例设计的依据。随着时间的推移，系统历史数据将会不断增加，这将对系统响应速度产生很大的影响。大数据量性能测试通常会模拟一个月、一季度、半年、一年、……的数据量进行测试，其中数据量的上限是系统历史记录转移前可能产生的最大数据量，模拟的时间点是系统预计转移数据的某一时间。

不同业务模式下的场景。同一系统可能会处于不同的业务模式，例如很多电子商务系统在早上8点到10点以浏览模式为主，10点到下午3点以定购模式为主，而在下午3点以后可能以混合模式为主。因此需要分析哪些模式是典型的即压力较大的模式，进而对这些模式单独进行测试，这样做可以有效的对系统瓶颈进行隔离定位。与“一天内不同时间段的场景测试”不同，“不同业务模式下的场景测试”更专注于某一种模式的测试，而“一天内不同时间段的场景测试”则多数是不同模式的混合场景，更接近用户的实际使用情况

### 什么是吞吐量？ 

网络定义：吞吐量是指在没有帧丢失的情况下，设备能够接受的最大速率。

软件工程定义：吞吐量是指在单位时间内中央处理器（CPU）从存储设备读取->处理->存储信息的量。

影响吞吐量因素：
- 1、存储设备的存取速度，即从存储器读出数据或数据写入存储器所需时间；
- 2、CPU性能：
        1）时钟频率；
        2）每条指令所花的时钟周期数（即CPI）；
        3）指令条数；
- 3、系统结构，如并行处理结构可增大吞吐量。

### 解释以下函数及他们的不同之处： 
- Lr_debug_message
- Lr_output_message
- Lr_error_message
- Lrd_stmt
- Lrd_fetch

#### 1. 【lr_debug_message函数组】 
##### int lr_debug_message (unsigned int message_level, const char *format, … ); 
        中文解释：lr_debug_message函数在指定的消息级别处于活动状态时发送一条调试信息。
        如果指定的消息级别未出于活动状态，则不发送消息。
        您可以从用户界面或者使用lr_set_debug_message， 将处于活动状态的消息级别设置为MSG_CLASS_BRIEF_LOG 或MSG_CLASSS_EXTENDED_LOG。
        要确定当前级别，请使用lr_get_debug_message。 
##### unsigned int lr_get_debug_message ( ); 
        中文解释：lr_get_debug_message函数返回当前的日志运行时设置。该设置确定发送到输出端的信息。日志设置是使用运行时设置对 话框或通过使用lr_set_debug_message函数指定的。 
##### int lr_set_debug_message (unsigned int message_level, unsigned int on_off); 
        中文解释：lr_set_debug_message函数设置脚本执行的调试消息级别message_lvl。
        通过设置消息级别，可以确定发送哪些信息。 启动设置的方法是将LR_SWITCH_ON作为on_off传递，禁用设置的方法是传递LR_SWITCH_OFF。
#### 2.【lr_output_message】 
##### int lr_output_message (const char *format, exp1, exp2,…expn.); 
        中文解释：lr_output_message函数将带有脚本部分的行号的消息发送到输出窗口和日志文件。
#### 3. 【lr_message】
##### int lr_message (const char *format, exp1, exp2,…expn.);
        中文解释：lr_message函数将信息发送到日志文件和输入窗口。在VuGen中运行时，输入文件为output.txt。 
#### 4. 【lr_log_message】 
##### int lr_log_message (const char *format, exp1, exp2,…expn.); 
        中文解释：lr_log_message函数将消息发送到Vuser或代理日志文件（取决于应用程序），而不是发送到输出窗口。通过向日志文件 发送错误消息或其他信息性消息，可以将该函数用于调试。 
#### 5. 【lr_error_message】 
##### int lr_error_message (const char *format, exp1, exp2,…expn. ); 
        中文解释：lr_error_message函数将错误消息发送到输出窗口和Vuser日志文件。要发送不是特定错误消息的特殊通知，请使用lr_output_message。
#### 6. 【lrd_stmt 】：
        将SQL语句与光标关联
#### 7. 【lrd_fetch】：
        提取结果集中得下一条记录


### 如何识别性能瓶颈？ 

性能瓶颈，可以侦测到使用显示器。这些显示器可能是应用服务器的监测，监控Web服务器，数据库服务器的监控和网络监控。他们帮助找到了动乱地区的情况，原因增加响应时间。该测量通常性能的响应时间，吞吐量，访问/秒，网络延迟图表等

### 响应时间和吞吐量之间的关系是什么？ 

吞吐量图显示的是虚拟用户每秒钟从服务器接收到的字节数。当和响应时间比较时，可以发现随着吞吐量的降低，响应时间也降低，同样的，吞吐量的峰值和最大响应时间差不多在同时出现。

### 以线程方式运行的虚拟用户有哪些优点？ 

VuGen提供了用多线程的便利。这使得在每个生成器上可以跑更多的虚拟用户。如果是以进程的方式跑虚拟用户，为每个用户加载相同的驱动程序到内存中，因此占用了大量的内存。这就限制了在单个生成器上能跑的虚拟用户数。如果按进程运行，给定的所有虚拟用户数（比如100）只是加载一个驱动程序实例到内存里。每个进程共用父驱动程序的内存，因此在每个生成器上可以跑更多的虚拟用户。

### LR中如何编写自定义函数？ 

在创建用户自定义函数前我们需要和创建DLL（external libary）。把库放在VuGen bin 目录下。一旦加了库，把自定义函数分配做一个参数。该函数应该具有一下格式：__declspec (dllexport) char* <function name>(char*, char*)。

### 如何调试LoadRunner脚本？ 

VuGen 包含两个选项来帮助调试 Vuser 脚本：“分步运行”命令和断点。这些选项不适用于VBscript 和 VB 应用程序类型的 Vuser。

要查看“调试”工具栏，请执行下列操作：

右键单击工具栏区域，然后选择“调试”。“调试”工具栏将显示在工具栏区域中。

“分步运行”命令

“分步运行”命令在运行脚本时一次运行一行。通过该命令，可以依次查看脚本每一行的执行情况。

要分步运行脚本，请执行下列操作：

- 1 依次选择“Vuser” > “分步运行”，或者单击“调试”工具栏上的“步骤”按钮。VuGen 将执行脚本的第一行。
- 2 继续单击“步骤”按钮来执行该脚本，直到脚本运行完成为止。

断点

通过断点可以使脚本在特定位置暂停执行。它可用于在执行期间的预定点处检查

该脚本对应用程序的影响。要管理书签，请参阅第 186 页上的“断点管理器”。

要设置断点，请执行下列操作：
- 1 将光标置于脚本中要停止执行的行上。
- 2 依次选择“插入” > “切换断点”，或者单击“调试”工具栏上的“断点”按钮。也可以按键盘上的 F9 键。将在脚本的左边距显示“断点”符号 ( )。
- 3 要禁用断点，请将光标置于包含断点符号的行上，然后单击“调试”工具栏上的“启用 / 禁用断点”按钮。“断点”符号中将会显示一个白点 ( )。禁用一个断点后，执行将在下一个断点处暂停。再次单击该按钮可以启用断点。要删除断点，请将光标置于包含断点符号的行上，然后单击“断点”按钮或者按F9 键。

要运行包含断点的脚本，请执行下列操作：
- 1 照常运行脚本。
        到达断点时， VuGen 将暂停脚本的执行。可以检查脚本运行到断点时的效果，并进行必要的更改，然后从断点处重新启动脚本。
- 2 要继续执行，请依次选择“Vuser” > “运行”。重新启动后，脚本将继续执行，直到遇到下一个断点或脚本完成。

断点管理器

可以使用断点管理器来查看和管理断点。通过断点管理器您可以操纵脚本中的所有断点。

要打开断点管理器，请选择“编辑” > “断点”。

要跳至脚本中的断点处，请执行下列操作：
- 1 从列表中选择一个断点。
- 2 单击“在脚本中突出显示”。则将在脚本中突出显示该行。

注意，每次只能突出显示一个断点。

管理断点

可以通过断点管理器添加、删除、禁用断点或者为断点设置条件

要添加断点，请执行下列操作：
- 1 单击“添加”。将打开“添加断点”对话框。
- 2 选择“操作”，并指定要添加断点的行号。
- 3 单击“确定”。该断点将被添加到断点列表中。

要删除断点，请执行下列操作：

- 1 要删除单个断点，请选择该断点并单击“删除”。
- 2 要立即删除所有断点，请单击“全部删除”。

要启用 / 禁用断点，请执行下列操作：

- 1 要启用断点，请在“操作”列内选中操作的复选框。
- 2 要禁用断点，请在“操作”列内清除操作的复选框。

通过断点管理器您可以将断点设置为在某些条件下暂停执行。

要为断点设置条件，请执行下列操作：

- 1 要在特定的迭代次数后暂停运行脚本，请选择“当迭代次数为下值时暂停”并输入所需的数字。
- 2 要在参数 X 具有特定值时暂停脚本，请选择“当参数 X 值为下值时暂停”并输入所需的值。有关参数的详细信息，请参阅第 8 章“使用 VuGen 参数”。

书签

当使用脚本视图时， VuGen 使您可以在脚本中各个不同的置放置书签。您可以在书签之间导航来分析和调试代码。

要创建书签，请执行下列操作：
- 1 将光标置于所需的位置，然后按 Ctrl + F2 组合键。VuGen 会在脚本的左边距放置一个图标。
- 2 要删除书签，请单击要删除的标签，然后按 Ctrl + F2 组合键。VuGen 将删除左边距处的图标。
- 3 要在书签之间移动，请执行下列操作：

要移动到下一个书签，请按 F2 键。

要导航到上一个书签，请按 Shift + F2 组合键

您还可以通过“编辑” > “书签”菜单项来创建书签和在书签之间进行导航。

*注意： 只能在当前操作中的书签之间导航。要导航到另一操作中的书签，请在左窗格中选择该操作然后按 F2 键。*

“转至”命令

要不使用书签在脚本中进行导航，可以使用“转至”命令。请依次选择“编辑”> “转至行”并指定脚本的行号。在树视图中也支持此种导航。

如果要检查特定步骤或函数的“回放日志”消息，请在 VuGen 中选择该步骤，然后依次选择“编辑” > “转至回放日志中的步骤”。VuGen 将把光标放置在“输出”窗口的“回放日志”选项卡中的相应步骤处。

### 你在VUGen中何时选择关闭日志？何时选择标准和扩展日志？ 

Run-time，log，

当调试脚本时，可以只输出错误日志，当在场景找你管加载脚本时，日志自动变为不可用。

Standard Log Option：选择标准日志时，就会在脚本执行过程中，生成函数的标准日志并且输出信息，供调试用。大型负载测试场景不用启用这个选项。

扩展日志包括警告和其他信息。大型负载测试不要启用该选项。用扩展日志选项，可以指定哪些附加信息需要加到扩展日志中

### 请解释一下如何录制web脚本？ 

解释：
- 1.基于浏览器的应用程序推荐使用HTML-based Script, 脚本中采用HTML页面的形式来表示，这种方式的Script脚本容易维护，容易理解，使用该选项中的advance中的第一个选项，如果单纯的HTML方式，是不允许使用关联的。
- 2．不是基于浏览器的应用程序推荐使用URL-based Script，脚本中的表示采用基于URL 的方式，不是很好阅读。

解释：
- 1 . 是否记录录制过程中的ThinkTime，如果记录，还可以设置最大值，一般我不记录这个值。
- 2．通知Vugen去重新设置每个action之间的Http context，缺省是需要的。
- 3．完整记录录制过程的log，
- 4．保存一个本地的snapshot，可以加速显示
- 5．把html的title放到web_reg_find函数里面
- 6 . 支持的字符集标准
- 7．Http header的录制，我们采用缺省即可，不需要用web_add_header去录制非标准的header信息。

### 对录制的content的内容进行filter，不作为resource处理的。

解释：这个就是我前面提到的关联，系统已经预先设置好了一些常见的关联rules，我们录制脚本之前，可以把系统的可以把系统的都关掉，定义自己的，只是有的时候，它不能自动关联，就干脆手工关联。

### 什么是场景？场景的重要性有哪些?如何设置场景? 

用例场景应该说是写测试用例，甚至是分析测试要素、设计测试策略另外一个重要的依据了。首先，软件研发最终是要再用户那里使用的，用例场景都将在用户的使用过程中被一一实现。其次，需求的文档会变，设计会变，但用户的用例场景是基本上不会变的（除非是政策或者战略上的变更）。这样使测试工作的任务更加明确了，也更加容易定义修改的优先级以及在修改建议上和开发人员达成一致。毕竟满足用户的用例场景是首要的。与微软等技术主导的软件企业相比，我向国内的软件更多的是市场主导，用户需求主导的软件企业和设计思想甚至开发模式。用例场景会比需求文档和分析报告更容易理解，同时也是对于理解用户的需求，产品设计更有帮助。在测试中能够帮助我们发现不仅仅是功能上的问题。

测试有两个目的：确认功能是否实现正确；确认软件是否实现了正确的功能。

### 什么是集合点？设置集合点有什么意义?Loadrunner中设置集合点的函数是哪个? 

插入集合点是为了衡量在加重负载的情况下服务器的性能情况。在测试计划中，可能会要求系统能够承受1000 人同时提交数据，在LoadRunner 中可以通过在提交数据操作前面加入集合点，这样当虚拟用户运行到提交数据的集合点时，LoadRunner 就会检查同时有多少用户运行到集合点，如果不到1000 人，LoadRunner 就会命令已经到集合点的用户在此等待，当在集合点等待的用户达到1000 人时，LoadRunner 命令1000 人同时去提交数据，从而达到测试计划中的需求。

说明：在脚本中设置了“集合点”后，当运行场景时可以对集合点进行设置，可以设置当百分之多少用户到达时，系统开始执行以下操作，详细的可以参考中文的用户手册

添加方法：
- 1、其中录制脚本script view中添加：lr_rendezvous(“XXX”);
- 2、在录制脚本的tree view里添加：rendezvous-XXX;

### LoadRunner由哪些部件组成？ 

使用LoadRunner 完成测试一般分为四个步骤：

- 1）Virtual User Generator 创建脚本
        创建脚本，选择协议
        录制脚本
        编辑脚本
        检查修改脚本是否有误
- 2）中央控制器（Controller）来调度虚拟用户
        创建Scenario，选择脚本
        设置机器虚拟用户数
        设置Schedule
        如果模拟多机测试，设置Ip Spoofer
- 3）运行脚本
        分析scenario
- 4）分析测试结果
