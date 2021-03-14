# 应用

应用服务器是指通过各种协议把商业逻辑曝露给客户端的程序。它提供了访问商业逻辑的途径以供客户端应用程序使用。应用服务器使用此商业逻辑就像调用对象的一个方法一样。

随着Internet的发展壮大,“主机/终端”或“客户机/服务器”的传统的应用系统模式已经不能适应新的环境,于是就产生了新的分布式应用系统,相应地,新的开发模式也应运而生，即所谓的“浏览器/服务器”结构、“瘦客户机”模式。应用服务器便是一种实现这种模式核心技术。

Web应用程序驻留在应用服务器(Application Server)上。应用服务器为Web应用程序提供一种简单的和可管理的对系统资源的访问机制。它也提供低级的服务，如HTTP协议的实现和数据库连接管理。Servlet容器仅仅是应用服务器的一部分。除了Servlet容器外，应用服务器还可能提供其他的Java EE(Enterprise Edition)组件，如EJB容器，JNDI服务器以及JMS服务器等。

市场上可以得到多种应用服务器，其中包括Apache的Tomcat、IBM的WebSphere Application Server、Caucho Technology的Resin、Macromedia的JRun、NEC WebOTX Application Server、JBoss Application Server、Oracle(并购了BEA)的WebLogic等。其中有些如NEC WebOTX Application Server、WebLogic、WebSphere不仅仅是Servlet容器，它们也提供对EJB(Enterprise JavaBeans)、JMS(Java Message Service)以及其他Java EE技术的支持。每种类型的应用服务器都有自己的优点、局限性和适用性。

## 应用服务器和WEB服务器的区别

通俗的讲，Web服务器传送(serves)页面使浏览器可以浏览，然而应用程序服务器提供的是客户端应用程序可以调用(call)的方法(methods)。确切一点，你可以说：Web服务器专门处理HTTP请求(request)，但是应用程序服务器是通过很多协议来为应用程序提供(serves)商业逻辑(business logic)。

### Web型

Web服务器(Web Server)可以解析(handles)HTTP协议。当Web服务器接收到一个HTTP请求(request)，会返回一个HTTP响应 (response)，例如送回一个HTML页面。为了处理一个请求(request)，Web服务器可以响应(response)一个静态页面或图片， 进行页面跳转(redirect)，或者把动态响应(dynamic response)的产生委托(delegate)给一些其它的程序例如CGI脚本，JSP(JavaServer Pages)脚本，servlets,ASP(Active Server Pages)脚本，服务器端(server-side)JavaScript,或者一些其它的服务器端(server-side)技术。无论它们(译者 注：脚本)的目的如何，这些服务器端(server-side)的程序通常产生一个HTML的响应(response)来让浏览器可以浏览。

企业WEB服务器是面向企业网络用户的信息交流平台,WEB在企业生产管理过程中的应用越来越多,是信息化应用的入口，一些应用系统都集成在WEB服务器上。要知道，Web服务器的代理模型(delegation model)非常简单。当一个请求(request)被送到Web服务器里来时，它只单纯的把请求(request)传递给可以很好的处理请求 (request)的程序(译者注：服务器端脚本)。Web服务器仅仅提供一个可以执行服务器端(server-side)程序和返回(程序所产生的)响 应(response)的环境，而不会超出职能范围。服务器端(server-side)程序通常具有事务处理(transaction processing)，数据库连接(database connectivity)和消息(messaging)等功能。

虽然Web 服务器不支持事务处理或数据库连接池，但它可以配置(employ)各种策略(strategies)来实现容错性(fault tolerance)和可扩展性(scalability)，例如负载平衡(load balancing)，缓冲(caching)。集群特征(clustering-features)经常被误认为仅仅是应用程序服务器专有的特征。

### 应用程序型

应用程序服务器(The Application Server)

根据定义，作为应用程序服务器，它通过各种协议，可以包括HTTP,把商业逻辑暴露给(expose)客户端应用程序。Web服务器主要是处理向 浏览器发送HTML以供浏览，而应用程序服务器提供访问商业逻辑的途径以供客户端应用程序使用。应用程序使用此商业逻辑就像你调用对象的一个方法(或过程 语言中的一个函数)一样。

应用程序服务器的客户端(包含有图形用户界面(GUI)的)可能会运行在一台PC、一个Web服务器或者甚至 是其它的应用程序服务器上。在应用程序服务器与其客户端之间来回穿梭(traveling)的信息不仅仅局限于简单的显示标记。相反，这种信息就是程序逻 辑(program logic)。 正是由于这种逻辑取得了(takes)数据和方法调用(calls)的形式而不是静态HTML,所以客户端才可以随心所欲的使用这种被暴露的商业逻辑。

在大多数情形下，应用程序服务器是通过组件(component)的应用程序接口(API)把商业逻辑暴露(expose)(给客户端应用程序)的，例 如基于J2EE(Java 2 Platform, Enterprise Edition)应用程序服务器的EJB(Enterprise JavaBean)组件模型。此外，应用程序服务器可以管理自己的资源，例如看大门的工作(gate-keeping duties)包括安全(security)，事务处理(transaction processing)，资源池(resource pooling)， 和消息(messaging)。就象Web服务器一样，应用程序服务器配置了多种可扩展(scalability)和容错(fault tolerance)技术。
