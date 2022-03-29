# 使用Java编写Tuxedo应用

# Oracle Tuxedo Java编程介绍

## 简介

Oracle Tuxedo服务可以使用纯java来编写。使用java实现的服务的功能和其他Tuxedo服务实现是一样的。你可以使用客户端或者Tuxedo服务器通过ATMI接口来调用Tuxedo Java Server（TMJSVASVR）对外提供的服务；你也在java实现的服务中通过TJATMI接口来调用Tuxedo server提供的服务。

另外，你可以使用任何类型的Tuxedo客户端调用java实现的服务，比如本地客户端，/WS客户端和Jolt客户端。

可以使用TJATMI接口、JATMI类型缓冲、POLO java对象等主流Java技术来实现Tuxedo服务。

## 编程方针

- Java服务类，实现Java服务，需要继承TuxedoJavaServer类；Java服务类应该有一个默认的构造函数
- Java服务类中的Java方法会被向外提供成Java服务，应该声明为public, 并将TPSVCINFO接口作为唯一的输入参数
- Java服务类应该实现tpsvrinit()方法，在Tuxedo Java服务启动时会被调用
- Java服务类应该实现tpsvrdone()方法，在Tuxedo Java服务关闭时会被调用
- Java服务可以使用Tuxedo Java ATMI接口（例如tpcall,tpbegin等）
- Java服务可以使用tpreturn向客户端返回结果，或者通过抛出异常退出

### Tuxedo Java 服务器线程与Java类实例模型

- Tuxedo Java服务使用传统的Tuxedo多线程模型，必须运行在多线程模式下
- 一旦启动，Tuxedo Java服务为每一个定义在配置文件中的类创建一个全局对象（实例），处理Java服务时工作线程共享全局对象（实例）

### Tudexo Java服务器 tpsvrinit()/tpsvrdone()处理

#### tpsvrinit()处理：
用户需要实现tpsvrinit()方法。由于该方法会在服务启动时调用，最好在该方法中完成类的初始化。如果一个类的tpsvrinit()方法失败，用户日志中会报告一条警告信息，Java服务会继续执行。

#### tpsvrdone()处理：
用户需要实现tpsvrinit()方法。该方法在服务关闭时调用，推荐将类范围的清理工作放入这个方法中。

### Tuxedo Java服务器tpreturn()处理

Java服务的tpreturn()并不会立即结束Java服务方法的执行，而是向Tuxedo Java服务器返回一个结果。

Java 服务的tpreturn()的行为与现有Tuxedo系统的tpreturn()行为不同：

- 当现有Tuxedo系统调用tpreturn()时，流控制自动转向Tuxedo
- 当Java服务调用tpreturn()时，tpreturn()之后的语句依旧会被执行。用户必须保证tpreturn()是Java服务中最后一条执行的语句。如果不是，建议在tpreturn()之后加上return；否则tpreturn()不会自动将流控制转向Tuxedo系统
*注意：不建议在Java服务中前面没有tpreturn()时使用return。这种用法会使Java服务器返回rcode为0的TPFAIL到相关的客户端。*

### Tuxedo Java服务器异常处理

- Java服务执行期间可以抛出任何的异常然后退出Java服务。这种情况下Java服务器会返回TPFAIL到其客户端，其中rcode设置为0
- 所有的异常信息会记录在$APPDIR/stderr文件中。
## 编程环境

### 更新UBB配置文件

你需要配置一个路径，通过该路径Tuxdeo Java服务器可以找到CLOPT中Java实现的服务的配置文件。

由于ATMI Java服务器是一个多线程服务器，你还需要指名线程分配的限制。可以查看Defining the Server Dispatch Threads一章获取更多关于多线程服务配置的信息。

清单2-1 显示了ATMI Java服务器的UBB配置文件示例：

清单2-1
```
*SERVERS
TMJAVASVR SRVGRP=TJSVRGRP SRVID=3
CLOPT="-- -c /home/oracle/app/javaserver/TJSconfig.xml"
MINDISPATCHTHREADS=2 MAXDISPATCHTHREADS=3
```
*注意：UBBCONFIG中为Java服务器指明的MAXDISPATCHTHREADS最小值为2。*

### ATMI Java Server 用户接口

#### TuxedoJavaServer

TuxedoJavaServer是一个抽象类，所有用户定义的实现服务的类都应该继承它。

表3-1 TuxedoJavaServer接口

|函数	|描述|
|------|----|
|tpsvrinit	|抽象方法，子类实现时做一些初始化的工作|
|tpsvrdone	|抽象方法，子类实现时做一些清理工作|
|getTuxAppContext	|用来取回当前连接的Tuxedo应用Java上下文|
#### Oracle Tuxedo Java上下文

为了获取Oracle Tuxedo Java Server提供的TJATMI原始功能，你需要获取一个TuxAppContext对象，该对象实现了所有的TJATMI功能

因为服务类继承自TuxedoJavaServer，你可以在服务中调用getTuxAppContext()方法获取上下文对象。然而，你不能在tpsvrinit()中或其TuxAppContext，因为此时TuxAppContext没有准备好。如果你在tpsvrinit()中尝试获取TuxAppContext，tpsvrinit()会出错并抛出异常。

#### Tuxedo Java 应用中的TJATMI功能

TJATMI是原生功能的集合，提供客户端和服务器端的通信功能，比如调用服务，开始和结束事务，获取到数据源的连接，日志等等。更多信息参考Java Server Javadoc.

表3-2 TJATMI功能

|名字	|操作|
|------|----|
|tpcall	|用于在请求/应答通信中同步调用Oracle Tuxedo服务|
|tpreturn	|用于在Tuxedo Java Server中设置返回值|
|tpbegin	|开始事务|
|tpcommit	|提交当前事务|
|tpabort	|终止当前事务|
|tpgetlev	|检查事务是否正在执行|
|getConnection	|获取到已配置的数据源的连接|
|userlog	|在Tuxedo用户日志文件中打印日志|
*注意：在tpreturn结束执行后服务依旧在运行。推荐把tpreturn作为服务中最后执行的语句。*

#### Tuxedo Java应用的类型缓冲

ATMI Java server 重用了Oracle WebLogic Tuxedo Connector TypedBuffers 作为相应的Oracle Tuxedo类型缓冲。消息通过类型缓冲传入 server 。ATMI Java server提供的类型缓冲见表3-3:

表3-3 类型缓冲

|缓冲类型	|描述|
|----------|---|
|TypedString	|数据是以null字符作为结束的字符数组时使用。Oracle Tuxedo 等价类型：STRING|
|TypedCArray	|数据是未定义字符数组（字节数组），任一字节都有可能是null。Oracle Tuxedo等价类型：CARRAY|
|TypedFML	|数据自定义时使用。每个数据域携带自己的标识，事件数，有可能有长度指示器。Oracle Tuxedo等价类型：FML|
|TypedFML32	|类似于TypedFML但是允许更大的字符范围和域，更大的缓冲。Oracle Tuxedo等价类型：FML32|
|TypedXML	|数据是基于XML的消息。Oracle Tuxedo等价类型：XML|
|TypedView	|应用使用Java结构，使用视图描述文件来定义缓冲结构。Oracle Tuxedo等价类型：VIEW|
|TypedView32	|类似于View，允许更大的字符范围、域、缓冲。Oracle Tuxedo等价类型：VIEW32|
更多关于类型缓冲的信息，参见"weblogic.wtc.jatmi"

#### 类型缓冲支持的限制

TypedFML32中Fldid()/Fname()嵌套在另一个TypedFML32中时无法工作。为了应对这种情况，你可以使用fieldtable类传输name/id。

目前weblogic.wtc.gwt.XmlViewCnv/XmlFmlCnv类无法使用。

获取/设置服务信息

使用TPSVCINFO类通过客户端获取/设置服务信息

表3-4 Getter函数

|函数	|描述|
|-------|---|
|getServiceData	用来返回Oracle |Tuxedo客户端发送过来的服务数据|
|getServiceFlags	|用来返回客户端发送过来的服务标识|
|getServiceName	|用来返回调用的服务名|
|getAppKey	|获取程序认证客户端密钥|
|getClientID	|获取客户端标识符|

#### 使用TuxATMIReply从服务请求中获取回应数据和元数据

表3-5 用于回应的Getter函数

|函数	|描述|
|------|----|
|getReplyBuffer	|返回从服务返回的类型缓冲（可能是null）|
|gettpurcode	|返回从服务返回的tpurcode|
#### 异常

你需要捕获服务中JATMI原语抛出的异常，比如tpcall()。JATMI可能抛出两种类型的异常：

- TuxATMITPException：该异常抛出表明TJATMI出错
- TuxATMITPReplyException：如果服务出错（TPESVCFAIL或者TPSVCERROR）该异常抛出，用户数据关联到异常中。
#### 跟踪

你还需要导出TMTRACE=atmi:ulog，正如你使用传统ATMI那样。TJATMI API跟踪信息被写入ULOG。

### 在Oracle Tuxedo Java Server 中实现服务

#### 典型过程

1. 定义一个继承自 TuxedoJavaServer的类
2. 提供一个默认的构造函数
3. 实现tpsvrinit()和tpsvrdone()方法
4. 实现服务方法，该方法应该使用TPSVCINFO作为唯一的参数

  - 使用getTuxAppContext()获取TuxAppContext对象
  - 使用TPSVCINFO.getServiceData()从TPSVCINFO对象中获取客户端请求数据
  - 如果配置了数据源，使用TuxAppContext.getConnection()方法获取到数据源的连接
  - 完成商业逻辑，比如使用TuxAppContext.tpcall()调用其他服务，操纵数据库等
  - 分配新的类型缓冲，把应答数据放入类型缓冲中
  - 调用TuxAppContext.tpreturn()将应答数据返回客户端
#### 实例：没有事务的Java服务实现

如下实例是实现TOUPPER服务的简单示例。

定义Java类
```
import weblogic.wtc.jatmi.TypedBuffer;
import weblogic.wtc.jatmi.TypedString;
import com.oracle.tuxedo.tjatmi.*;
public class MyTuxedoJavaServer extends TuxedoJavaServer {
    public MyTuxedoJavaServer()
    {
        return;
    }

    public int tpsvrinit() throws TuxException
    {
        System.out.println("MyTuxedoJavaServer.tpsvrinit()");
        return 0;
    }

    public void tpsvrdone()
    {
        System.out.println("MyTuxedoJavaServer.tpsvrdone()");
        return;
    }

    public void JAVATOUPPER(TPSVCINFO rqst) throws TuxException {
        TypedBuffer svcData;
        TuxAppContext myAppCtxt = null;
        TuxATMIReply myTuxReply = null;
        TypedBuffer replyTb = null;

        /* Get TuxAppContext first */
        myAppCtxt = getTuxAppContext();

        svcData = rqst.getServiceData();
        TypedString TbString = (TypedString)svcData;
        myAppCtxt.userlog("Handling in JAVATOUPPER()");
        myAppCtxt.userlog("Received string is:" + TbString.toString());
        String newStr = TbString.toString();
        newStr = newStr.toUpperCase();
        TypedString replyTbString = new TypedString(newStr);
        /* Return new string to client */
        myAppCtxt.tpreturn(TPSUCCESS, 0, replyTbString, 0);
    }

    public void JAVATOUPPERFORWARD(TPSVCINFO rqst) throws TuxException {
        TypedBuffer svcData;
        TuxAppContext myAppCtxt = null;
        TuxATMIReply myTuxReply = null;
        TypedBuffer replyTb = null;
        long flags = TPSIGRSTRT;
        /* Get TuxAppContext first */
        myAppCtxt = getTuxAppContext();
        svcData = rqst.getServiceData();
        TypedString TbString = (TypedString)svcData;

        myAppCtxt.userlog("Handling in JAVATOUPPERFORWARD()");
        myAppCtxt.userlog("Received string is:" + TbString.toString());
        /* Call another service "TOUPPER" which may be implemented by another Tuxedo Server */
        try {
            myTuxReply = myAppCtxt.tpcall("TOUPPER", svcData, flags);
            /* If success, get reply buffer */
            replyTb = myTuxReply.getReplyBuffer();
            TypedString replyTbStr = (TypedString)replyTb;
            myAppCtxt.userlog("Replied string from TOUPPER:" + replyTbStr.toString());
            /* Return the replied buffer to client */
            myAppCtxt.tpreturn(TPSUCCESS, 0, replyTb, 0);
        } catch (TuxATMITPReplyException tre) {
            myAppCtxt.userlog("TuxATMITPReplyException:" + tre);
            myAppCtxt.tpreturn(TPFAIL, 0, null, 0);
        } catch (TuxATMITPException te) {
            myAppCtxt.userlog("TuxATMITPException:" + te);
            myAppCtxt.tpreturn(TPFAIL, 0, null, 0);
        }
    }
}
```
#### 创建Java Server配置文件

清单4-2显示了配置示例，将MyTuxedoJavaServer.JAVATOUPPER()方法导出成Tuxedo 服务JAVATOUPPER，将MyTuxedoJavaServer.JAVATOUPPERFORWARD()方法导出成Tuxedo 服务JAVATOUPPERFORWARD。

清单4-2
```
<?xml version="1.0" encoding="UTF-8"?>
<TJSconfig>
    <TuxedoServerClasses>
        <TuxedoServerClass name="MyTuxedoJavaServer"> </TuxedoServerClass>
    </TuxedoServerClasses>
</TJSconfig>
```
#### 更新UBB配置文件

清单4-3 UBB配置文件
```
*GROUPS
TJSVRGRP LMID=simple GRPNO=2
*SERVERS
TMJAVASVR SRVGRP= TJSVRGRP SRVID=4 CLOPT="-- -c TJSconfig.xml"
MINDISPATCHTHREADS=2 MAXDISPATCHTHREADS=2
```
### 实例：带有事务的Java Service实现

清单4-4给出了一个示例，实现WRITEDB_SVCTRN_COMMIT服务，该服务将用户请求字符串插入表TUXJ_TRAN_TEST中。

定义Java类

清单4-4
```
import weblogic.wtc.jatmi.TypedBuffer;
import weblogic.wtc.jatmi.TypedString;
import com.oracle.tuxedo.tjatmi.*;
import java.sql.SQLException;
/* MyTuxedoTransactionServer is user defined class */
public class MyTuxedoTransactionServer extends TuxedoJavaServer{
    public MyTuxedoTransactionServer ()
    {
        return;
    }

    public int tpsvrinit() throws TuxException
    {
        System.out.println("In MyTuxedoTransactionServer.tpsvrinit()");
        return 0;
    }

    public void tpsvrdone()
    {
        System.out.println("In MyTuxedoTransactionServer.tpsvrdone()");
        return;
    }

    public void WRITEDB_SVCTRN_COMMIT(TPSVCINFO rqst) throws TuxException {
        TuxAppContext myAppCtxt;
        TypedBuffer rplyBuf = null;
        String strType = "STRING";
        String ulogMsg;
        TypedString rqstMsg;
        Connection connDB = null;
        Statement stmtDB = null;
        String stmtSQL;
        int trnLvl, trnStrtInSVC;
        int trnRtn;
        int rc = TPSUCCESS;
        rqstMsg = (TypedString)rqst.getServiceData();
        myAppCtxt = getTuxAppContext();
        myAppCtxt.userlog("JAVA-INFO: Request Message Is \"" + rqstMsg.toString() + "\"");
        rplyBuf = new TypedString("This Is a Simple Transaction Test from Tuxedo Java Service");
        long trnFlags = 0;
        try {
            trnStrtInSVC = 0;
            trnLvl = myAppCtxt.tpgetlev();
            if (0 == trnLvl) {
                long trnTime = 6000;
                myAppCtxt.userlog("JAVA-INFO: Start a transaction...");
                trnRtn = myAppCtxt.tpbegin(trnTime, trnFlags);
                myAppCtxt.userlog("JAVA-INFO: tpbegin return " + trnRtn);
                trnStrtInSVC = 1;
            }
            connDB = myAppCtxt.getConnection();
            if (null != connDB) {
                myAppCtxt.userlog("JAVA-INFO: Get connection: (" + connDB.toString() + ").");
            }
            stmtDB = connDB.createStatement();
            if (null != stmtDB) {
                myAppCtxt.userlog("JAVA-INFO: Create statement: (" + stmtDB.toString() + ").");
            }
            stmtSQL = "INSERT INTO TUXJ_TRAN_TEST VALUES ('" + rqstMsg.toString() + "')";
            myAppCtxt.userlog("JAVA-INFO: Start to execute sql (" + stmtSQL + ")...");
            stmtDB.execute(stmtSQL);
            myAppCtxt.userlog("JAVA-INFO: End to execute sql (" + stmtSQL +
").");
            if (1 == trnStrtInSVC) {
                myAppCtxt.userlog("JAVA-INFO: tpcommit current transaction...");
                trnRtn = myAppCtxt.tpcommit(trnFlags);
                myAppCtxt.userlog("JAVA-INFO: tpcommit return " + trnRtn);
                trnStrtInSVC = 0;
                if (-1 == trnRtn ) {
                    rc = TPFAIL;
                }
            }
        } catch (TuxATMIRMException e) {
            String errMsg = "ERROR: TuxATMIRMException: (" + e.getMessage() + ").";
            myAppCtxt.userlog("JAVA-ERROR: " + errMsg);
            rc = TPFAIL;
        } catch (TuxATMITPException e) {
            String errMsg = "ERROR: TuxATMITPException: (" + e.getMessage() + ").";
            myAppCtxt.userlog("JAVA-ERROR: " + errMsg);
            rc = TPFAIL;
        } catch (SQLException e) {
            String errMsg = "ERROR: SQLException: (" + e.getMessage() + ").";
            myAppCtxt.userlog("JAVA-ERROR: " + errMsg);
            rc = TPFAIL;
        } catch (Exception e) {
            String errMsg = "ERROR: Exception: (" + e.getMessage() + ").";
            myAppCtxt.userlog("JAVA-ERROR: " + errMsg);
            rc = TPFAIL;
        } catch (Throwable e) {
            String errMsg = "ERROR: Throwable: (" + e.getMessage() + ").";
            myAppCtxt.userlog("JAVA-ERROR: " + errMsg);
            rc = TPFAIL;
        } finally {
            if (null != stmtDB) {
                try {
                    stmtDB.close();
                } catch (SQLException e) {}
            }
        }
        myAppCtxt.tpreturn(rc, 0, rplyBuf, 0);
    }
}
```
创建Java 服务配置文件

表4-5
```
<?xml version="1.0" encoding="UTF-8"?>
<TJSconfig>
    <ClassPaths>
    <ClassPath>/home/oracle/app/oracle/product/11.2.0/dbhome_2/ucp/lib/ucp.jar
    </ClassPath>
    <ClassPath>/home/oracle/app/oracle/product/11.2.0/dbhome_2/jdbc/lib/ojdbc6.jar</ClassPath>
    </ClassPaths>

    <DataSources>
    <DataSource name="oracle">
    <DriverClass>oracle.jdbc.xa.client.OracleXADataSource</DriverClass>
    <JdbcDriverParams>
    <ConnectionUrl>jdbc:oracle:thin:@//10.182.54.144:1521/javaorcl</ConnectionUrl>
    </JdbcDriverParams>
    </DataSource>
    </DataSources>

    <TuxedoServerClasses>
    <TuxedoServerClass name=" MyTuxedoTransactionServer">
    </TuxedoServerClass>
    </TuxedoServerClasses>
</TJSconfig>
```
更新UBB配置文件

清单4-6
```
*GROUPS
ORASVRGRP LMID=simple GRPNO=1
OPENINFO="Oracle_XA:Oracle_XA+Acc=P/scott/triger+SesTm=120+MaxCur=5+LogDir=.+SqlNet=javaorcl"
TMSNAME=TMSORA TMSCOUNT=2
*SERVERS
TMJAVASVR SRVGRP=ORASVRGRP SRVID=3
    CLOPT="-- -c TJSconfig.xml"
    MINDISPATCHTHREADS=2 MAXDISPATCHTHREADS=4
```