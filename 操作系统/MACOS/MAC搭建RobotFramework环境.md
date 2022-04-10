# MAC搭建RobotFramework环境

## 一、安装ptyhon环境

下载地址：https://www.python.org/

## 二、安装Robot Framework

下载地址：https://pypi.python.org/pypi/robotframework/3.0.2

下载后解压，打开终端切换到解压目录下，然后执行 python setup.py install 安装。

也可使用命令直接安装`pip install robotframework`

## 三、安装wxPython

Wxpython 是python 非常有名的一个GUI库，因为RIDE 是基于这个库开发的，所以这个必须安装。

方法1:使用命令行安装，需要先安装homebrew, 然后执行`brew install wxpython`安装wxpython。

方法2:下载安装，下载地址：http://www.wxpython.org/download.php 或 https://sourceforge.net/projects/wxpython/files/wxPython/ ，下载whl安装文件后，执行`pip install *.whl`进行安装。

## 四、安装Robot Framework-ride

下载地址：https://pypi.python.org/pypi/robotframework-ride

或使用命令`pip install robotframework-ride`进行安装。

RIDE就是一个图形界面的用于创建、组织、运行测试的软件。

下载后解压，打开终端切换到解压目录下，执行 sudo easy_install robotframework-ride 安装。

## 五、安装Robot Framework-senlenium2library

下载地址：https://pypi.python.org/pypi/robotframework-selenium2library/1.5.0

RF-seleniumlibrary 可以看做RF版的selenium 库，selenium （webdriver）可以认为是一套基于web的规范（API），所以，RF 、appium 等测试工具都可以基于这套API进行页面的定位与操作。

方法1:下载后解压，打开终端切换到解压目录下，执行 sudo easy_install robotframework-selenium2library安装。

方法2:可以通过python的pip工具包进行安装，`pip install robotframework-selenium2library`

## 六、安装完成后启动

安装好RF-ride之后，在终端输入`ride.py`即可启动。

启动Ride可能会报错，错误信息如下：
```
python should be executed in 32-bit mode with wxPython on OSX
```
解决方案：
```
# 在控制台输入此行命令即可解决
defaults write com.apple.versioner.python Prefer-32-Bit -bool yes
```