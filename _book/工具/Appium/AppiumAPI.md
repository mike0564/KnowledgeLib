# AppiumAPI

## 1、创建新的会话

创建一个新的会话
```
DesiredCapabilities desiredCapabilities =new DesiredCapabilities();
desiredCapabilities.setCapability(MobileCapabilityType.PLATFORM_VERSION,"10.3");
desiredCapabilities.setCapability(MobileCapabilityType.DEVICE_NAME,"iPhone Simulator");
desiredCapabilities.setCapability(MobileCapabilityType.AUTOMATION_NAME,"XCUITest");
desiredCapabilities.setCapability(MobileCapabilityType.APP,"/path/to/ios/app.zip");
URL url = newURL("http://127.0.0.1:4723/wd/hub");
IOSDriver driver = new IOSDriver(url,desiredCapabilities);
String sessionId =driver.getSessionId().toString();
```

## 2、结束会话

结束正在运行的会话

```
driver.quit();
```

## 3、获取会话功能

检索指定会话的功能

```
Map<String, Object> caps = driver.getSessionDetails();
```

## 4、回退

如果可能，在浏览器历史记录中向后浏览（仅限Web上下文）

```
driver.back();
```

## 5、截图

截取当前的视口/窗口/页面

```
File scrFile =((TakesScreenshot)driver).getScreenshotAs(OutputType.FILE);
```

## 6、超时

### 设置超时

配置特定类型的操作在被中止之前可以执行的时间量

```
driver.manage().timeouts().pageLoadTimeout(30,TimeUnit.SECONDS);
```

### 设置隐式等待超时

设置搜索元素时驱动程序应该等待的时间量

```
driver.manage().timeouts().implicitlyWait(30,TimeUnit.SECONDS);
```

### 设置脚本超时

设置的时间量，以毫秒为单位，通过执行异步脚本执行异步允许运行它们都将立即中止之前（仅限于Web上下文）

```
driver.manage().timeouts().setScriptTimeout(30,TimeUnit.SECONDS);
```

## 7、方向
 
### 获取方向

获取当前的设备/浏览器方向

```
ScreenOrientation orientation =driver.getOrientation();
```

### 设置方向

设置当前的设备/浏览器方向

```
driver.rotate(ScreenOrientation.LANDSCAPE);
```

## 8、地理位置
 
### 获取地理位置

获取当前的地理位置

```
Location location = driver.location();
//必须是一个驱动程序，实现了LocationContext
```

### 设置地理位置

设置当前的地理位置

```
driver.setLocation(new Location(49, 123,10));
//必须是一个驱动程序，实现了LocationContext
```

## 9、日志
 
### 获取可用的日志类型

获取给定日志类型的日志。日志缓冲区在每次请求后都会重置

```
Set<String> logTypes =driver.manage().logs().getAvailableLogTypes();
```

### 获取日志

获取给定日志类型的日志。日志缓冲区在每次请求后都会重置

```
LogEntries logEntries =driver.manage().logs().get("driver");
```

## 10、设置
 
### 更新设备设置

更新设备上的当前设置

```
driver.setSetting(Setting.WAIT_FOR_IDLE_TIMEOUT,Duration.ofSeconds(5));
```

### 检索设备设置

检索设备上的当前设置

```
Map<String, Object> settings =driver.getSettings();
```

## 11、活动
 
### 开始活动

通过提供软件包名称和活动名称来开始Android活动

``` 
driver.startActivity(newActivity("com.example", "ActivityName"));
```

### 获取当前活动

获取当前Android活动的名称

```
String activity = driver.currentActivity();
```

### 获取当前包

获取当前Android包的名称

```
String package =driver.getCurrentPackage();
```

## 12、应用

## 安装应用程序

将给定的应用程序安装到设备上

```
driver.installApp("/Users/johndoe/path/to/app.apk");
```

### 应用程序已安装

检查设备上是否安装了指定的应用程序

```
driver.isAppInstalled("com.example.AppName");
```

### 启动应用程序

在设备上启动应用程序

```
driver.launchApp();
```

### 背景应用程序

将当前正在运行的应用程序发送到后台

```
driver.runAppInBackground(Duration.ofSeconds(10));
```

### 关闭应用程序

关闭设备上的应用

```
driver.closeApp();
```

### 重置应用程序

重置此会话的当前正在运行的应用程序

```
driver.resetApp();
```

### 删除应用程序

从设备中删除应用程序

```
driver.removeApp("com.example.AppName");
```

### 获取应用程序字符串

获取应用程序字符

```
Map<String, String> appStrings =driver.getAppStringMap("en", "/path/to/file");
```

### 结束测试覆盖率

获取测试覆盖率数据

```
driver.endTestCoverage("Intent","/path");
```

## 13、文件
 
### 推送文件

将文件放置在设备的特定位置

```
driver.pushFile("/path/to/device/foo.bar",new File("/Users/johndoe/files/foo.bar"));
```

### 拉文件

从设备的文件系统中检索文件

```
byte[] fileBase64 =driver.pullFile("/path/to/device/foo.bar");
```

### 拉文件夹

从设备的文件系统中检索文件夹

```
byte[] folder =driver.pullFolder("/path/to/device/foo.bar");
```

## 14、互动

### 摇

在设备上执行摇动操作

```
driver.shake();
```

### 锁

锁定设备

```
driver.lockDevice();
```

### 开锁

解锁设备

```
driver.lockDevice();
driver.unlockDevice();
```

### 设备是否被锁定

检查设备是否被锁定

```
boolean isLocked = driver.isLocked();
```

### 旋转

旋转三维设备

```
driver.rotate(new DeviceRotation(10, 10,10));
```

## 15、按键

###按键代码

按下设备上的特定按键

```
driver.pressKeyCode(AndroidKeyCode.SPACE,AndroidKeyMetastate.META_SHIFT_ON);
```

### 长按键代码

按住设备上的特定键码

```
driver.longPressKeyCode(AndroidKeyCode.HOME);
```

### 隐藏键盘

隐藏软键盘

```
driver.hideKeyboard();
```

### 显示键盘

是否显示软键盘

```
boolean isKeyboardShown =driver.isKeyboardShown();
```

## 16、网络
 
### 切换飞行模式

在设备上切换飞行模式

```
//Java不支持
```

### 切换数据

切换数据服务的状态

``` 
//Java不支持
```

### 切换WiFi

切换wifi服务的状态

```
//Java不支持
```

### 切换位置服务

切换位置服务的状态

```
driver.toggleLocationServices();
```

### 发简讯

模拟短信（仅适用于仿真器）

``` 
//Java不支持
```

### GSM呼叫

拨打GSM电话（仅限Emulator）

``` 
//Java不支持
```

### GSM信号

设置GSM信号强度（仅限仿真器）

``` 
//Java不支持
```

### GSM语音
设置GSM语音状态（仅适用于仿真器）

``` 
//Java不支持
```
 
## 17、性能数据
 
### 获取性能数据

返回支持读取的系统状态信息，如CPU，内存，网络流量和电池

```
List<List<Object>>performanceData = driver.getPerformanceData("my.app.package","cpuinfo", 5);
```

### 获取性能数据类型

返回支持读取的系统状态的信息类型，如CPU，内存，网络流量和电池

```
List<String> performanceTypes =driver.getSupportedPerformanceDataTypes();
```

## 18、模拟器
 
### 执行Touch ID

模拟触摸ID事件（仅适用于iOS模拟器）

```
driver.performTouchID(false); 
//模拟失败的触摸
driver.performTouchID(true); 
//模拟通过的触摸
```

### 切换触摸ID注册

切换正在注册的模拟器以接受touchId（仅适用于iOS模拟器）

``` 
driver.toggleTouchIDEnrollment(true);
```

## 19、系统
 
### 打开通知

打开Android通知（仅适用于仿真器）

``` 
driver.openNotifications();
```

### 获取系统栏

检索状态和导航栏的可见性和边界信息

``` 
Map<String, String> systemBars =driver.getSystemBars();
```

### 获取系统时间

在设备上获取时间

``` 
String time = driver.getDeviceTime();
```

## 20、查找元素
 
### 查找元素

搜索页面上的元素

``` 
MobileElement elementOne = (MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
MobileElement elementTwo = (MobileElement)driver.findElementByClassName("SomeClassName");
```

## 21、操作
 
### 点击

点击中心点的元素

```
MobileElement el = driver.findElementByAccessibilityId("SomeId");
el.click();
```

### 发送键

将一系列击键发送到一个元素

``` 
MobileElement element = (MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
element.sendKeys("Hello world!");
```

### 清除元素

清除元素的值

``` 
MobileElement element = (MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
element.clear();
```

## 22、属性
 
### 获取元素文本

返回元素的可见文本

``` 
MobileElement element = (MobileElement)driver.findElementByClassName("SomeClassName");
let elText = element.getText();
```

### 获取标签名称

获取元素的标签名称

``` 
List<MobileElement> element =(MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
String tagName = element.getTagName();
```

### 获取元素属性

获取元素属性的值

``` 
List<MobileElement> element =(MobileElement) driver.findElementByAccessibilityId("SomeAccessibilityID");
String tagName =element.getAttribute("content-desc");
```

### 元素被选中

确定是否选择了表单或表单类元素（复选框，选择等）

``` 
MobileElement element = (MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
boolean isSelected = element.isSelected();
```
 
### 元素已启用

确定元素当前是否启用

``` 
MobileElement element = (MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
boolean isEnabled = element.isEnabled();
```

### 获取元素位置

确定元素在页面或屏幕上的位置

``` 
List<MobileElement> element =(MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
Point location = element.getLocation();
```

### 获取元素大小

以像素为单位确定元素的大小

``` 
List<MobileElement> element =(MobileElement) driver.findElementByAccessibilityId("SomeAccessibilityID");
Dimension elementSize = element.getSize();
```

### 获取元素矩形

获取元素的尺寸和坐标

``` 
List<MobileElement> element =(MobileElement)driver.findElementByAccessibilityId("SomeAccessibilityID");
Rectangle rect = element.getRect();
```

### 获取元素CSS值

查询Web元素的计算CSS属性的值

``` 
List<MobileElement> element =(MobileElement) driver.findElementById("SomeId");
String cssProperty =element.getCssValue("style");
```

### 在视图中获取元素位置

一旦将元素滚动到视图中，确定元素在屏幕上的位置

（主要是内部命令并且不被所有客户端支持）

``` 
//Java不支持
```
 
## 23、其他
 
### 提交表单

提交一个FORM元素

``` 
MobileElement element = (MobileElement)driver.findElementByClassName("SomeClassName");
element.submit();
```

### 获取活动元素

获取当前会话的活动元素

``` 
WebElement currentElement =driver.switchTo().activeElement();

```

### 元素是否相等

测试两个元素ID是否指向相同的元素

``` 
//重写equals方法的java对象
MobileElement elementOne = (MobileElement)driver.findElementByClassName("SomeClassName");
MobileElement elementTwo = (MobileElement)driver.findElementByClassName("SomeOtherClassName");
boolean isEqual =elementOne.equals(elementTwo);
```

## 24、上下文
 
### 获取当前上下文

获取Appium正在运行的当前上下文

``` 
String context = driver.getContext();
```

### 获取所有上下文

获取所有可用的自动化上下文

``` 
Set<String> contextNames =driver.getContextHandles();
```

### 设置当前上下文

设置自动化的上下文

``` 
Set<String> contextNames =driver.getContextHandles();
for (String contextName : contextNames) {
   System.out.println(contextNames); 
//打印出NATIVE_APP/WEBVIEW_1
}
driver.context(contextNames.toArray()[1]); 
//设置上下文为WEBVIEW_1
。。。。。。
driver.context("NATIVE_APP");
//设置上下文为NATIVE_APP
```

## 25、鼠标
 
### 将鼠标移至

将鼠标移动特定元素的偏移量

``` 
Actions action = new Actions(driver);
action.moveTo(element, 10, 10);
action.perform()
```
 
### 点击

在当前鼠标坐标点击任意鼠标按钮

``` 
Actions action = new Actions(driver);
action.moveTo(element);
action.click();
action.perform();
```

### 双击

双击当前鼠标坐标（由moveto设置）

``` 
Actions action = new Actions(driver);
action.moveTo(element);
action.doubleClick();
action.perform();
```

### 按钮关闭

在当前的鼠标坐标上单击并按住鼠标左键

``` 
Actions action = new Actions(driver);
action.moveTo(element);
action.clickAndHold();
action.perform();
```
### 释放按钮

释放先前保持的鼠标按钮

``` 
Actions action = new Actions(driver);
action.moveTo(element);
action.clickAndHold();
action.moveTo(element, 10, 10);
action.release();
action.perform();
```

## 26、触摸
 
### 单击

单击轻触设备

``` 
TouchActions action = newTouchActions(driver);
action.singleTap(element);
action.perform();
```

### 双击

使用手指动作事件双击触摸屏

``` 
TouchActions action = newTouchActions(driver);
action.doubleTap(element);
action.perform();
```

### 移动

手指在屏幕上移动

``` 
TouchActions action = newTouchActions(driver);
action.down(10, 10);
action.move(50, 50);
action.perform();
```

### 触摸下来

手指在屏幕上

``` 
TouchActions action = newTouchActions(driver);
action.down(10, 10);
action.move(50, 50);
action.perform();
```

### 润色（作小的修改）

手指在屏幕上

``` 
TouchActions action = newTouchActions(driver);
action.down(10, 10);
action.up(20, 20);
action.perform();
```

### 长按

使用手指运动事件长按触摸屏

``` 
TouchActions action = newTouchActions(driver);
action.longPress(element);
action.perform();
```

### 滚动

使用基于手指的动作事件在触摸屏上滚动

``` 
TouchActions action = newTouchActions(driver);
action.scroll(element, 10, 100);
action.perform();
```

### 拂去

使用手指运动事件轻击触摸屏

``` 
TouchActions action = newTouchActions(driver);
action.flick(element, 1, 10, 10);
action.perform();
```

### 多点触摸执行

执行多点触摸动作序列

``` 
TouchAction actionOne = new TouchAction();
actionOne.press(10, 10);
actionOne.moveTo(10, 100);
actionOne.release();
TouchAction actionTwo = new TouchAction();
actionTwo.press(20, 20);
actionTwo.moveTo(20, 200);
actionTwo.release();
MultiTouchAction action = newMultiTouchAction();
action.add(actionOne);
action.add(actionTwo);
action.perform();
```

### 触摸执行

执行一个触摸动作序列

``` 
TouchAction action = new TouchAction(driver);
action.press(10, 10);
action.moveTo(10, 100);
action.release();
action.perform();
```

## 27、窗口
 
### 切换到窗口

将焦点更改为另一个窗口（仅限Web上下文）

``` 
driver.switchTo().window("handle");
```

### 关闭窗口

关闭当前窗口（仅限Web上下文）

``` 
driver.close();
```

### 获取窗口句柄

检索当前窗口句柄（仅限Web上下文）

``` 
String windowHandle =driver.getWindowHandle();
```

### 获取所有窗口句柄

检索可用于会话的所有窗口句柄的列表（仅限Web上下文）

``` 
Set<String> windowHandles =driver.getWindowHandles();
```

### 获取标题

获取当前页面标题（仅限Web上下文）

``` 
String title = driver.getTitle();
```

### 获取窗口大小

获取指定窗口的大小（仅限Web上下文）

``` 
Dimension windowSize =driver.manage().window().getSize();
```
 
### 设置窗口大小

更改指定窗口的大小（仅限Web上下文）

``` 
driver.manage().window().setSize(newDimension(10, 10));
```
 
### 获取窗口位置

获取指定窗口的位置（仅限Web上下文）

``` 
Point windowPosition =driver.manage().window().getPosition();
```

### 设置窗口位置

更改指定窗口的位置（仅限Web上下文）
 
```
driver.manage().window().setPosition(newDimension(10, 10));
```

### 最大化窗口

最大化指定的窗口（仅限Web上下文）

``` 
driver.manage().window().maximize();
```

## 28、导航
 
### 导航到URL

导航到新的URL（仅限Web上下文）

``` 
driver.get("http://appium.io/");
```

### 获取URL

检索当前页面的URL（仅限Web上下文）

``` 
String url = driver.getCurrentUrl();
```

### 前进

如果可能，在浏览器历史记录中向前浏览（仅限Web上下文）

``` 
driver.forward();
```

### 刷新

刷新当前页面（仅限Web上下文）

``` 
driver.refresh();
```

## 29、Cookie
 
### 获取所有Cookie

检索当前页面可见的所有cookie（仅限Web上下文）

``` 
Set<Cookie> allcookies =driver.manage().getCookies();
```

### 设置Cookie

设置一个cookie（仅限Web上下文）

``` 
driver.manage().addCookie(newCookie("foo", "bar"));
```

### 删除Cookie

删除具有给定名称的cookie（仅限Web上下文）

``` 
driver.manage().deleteCookieNamed("cookie_name");
```

### 删除所有Cookie

删除当前页面可见的所有cookie（仅限Web上下文）

``` 
driver.manage().deleteAllCookies();
```

## 30、Frame
 
### 切换到帧

将焦点更改为页面上的其他框架（仅限Web上下文）

``` 
driver.switchTo().frame(3);
```

### 切换到父框架

将焦点更改为父上下文（仅限Web上下文）

``` 
driver.switchTo().parentFrame();
```

## 31、JavaScript
 
### 执行脚本

将JavaScript片段注入页面以在当前选定框架的上下文中执行（仅限Web上下文）

``` 
((JavascriptExecutor)driver).executeScript("window.setTimeout(arguments[arguments.length - 1],500);");
```

### 执行异步脚本

将JavaScript片段注入页面以在当前选定框架的上下文中执行（仅限Web上下文）

``` 
((JavascriptExecutor)driver).executeAsyncScript("window.setTimeout(arguments[arguments.length -1], 500);");
```
