# Jmeter参数化

JMeter也有像LR中的参数化，本篇就来介绍下JMeter的参数化如何去实现。

**参数化**：录制脚本中有登录操作，需要输入用户名和密码，假如系统不允许相同的用户名和密码同时登录，或者想更好的模拟多个用户来登录系统。

这个时候就需要对用户名和密码进行参数化，使每个虚拟用户都使用不同的用户名和密码进行访问。

## 一、准备脚本，测试数据

1. 录制一个脚本（可以用badboy工具录制），在jmeter中打开，找到有用户名和密码的页面。

如下：

![](./images/Jmeter_06_01.png)

2. 我们需要“参数化”的数据，用记事本写了五个用户名和密码，保存为.dat格式的文件，编码问题在使用CSV Data Set Config参数化时要求的比较严格，记事本另存为修改编码UTF-8。

![](./images/Jmeter_06_02.png)

我将这个文件放在了我的（ C:\JmeterWorkSpace\t.dat  ）路径下。
***注意用户名和密码是一一对应的，中间用户逗号（，）隔开。***

## 二、参数化

这里介绍两种参数化的方式：函数助手，CSV Data Set Config。

### 1. 借助函数助手的方式

#### a、点击菜单栏“选项”---->函数助手对话框，看下图:  CSV文件列号是从0开始的，第一列0、第二列1、第三列2、依次类推。

![](./images/Jmeter_06_03.png)
#### b、复制生成的参数化函数，打开登陆请求页面，在右则的参数化中找到我们要参数化的字段，这里对用户名和密码做参数化，第一列是用户名，列号为0；第二列是密码，列号为1；修改函数中对应的参数化字段列号就可以啦。

![](./images/Jmeter_06_04.png)

好了，现在我们的参数化设置完成，在脚本的时候，会调用我们C:\JmeterWorkSpace盘下面的t.dat文件，第一列是用户，第二列是密码。

### 2. 借助jmeter中的配置元件（CSV Data Set Config）
#### a、选中线程组，点击右键，添加－配置元件－CSV Data Set Config
![](./images/Jmeter_06_05.png)

说明：
```
Filename --- 参数项文件
File Encoding --- 文件的编码，设置为UTF-8
Vaiable Names --- 文件中各列所表示的参数项；各参数项之间利用逗号分隔；参数项的名称应该与HTTP Request中的参数项一致。
Delimiter --- 如文件中使用的是逗号分隔，则填写逗号；如使用的是TAB，则填写\t；(如果此文本文件为CSV格式的，默认用英文逗号分隔)
Recycle on EOF? --- True=当读取文件到结尾时，再重头读取文件
                    False=当读取文件到结尾时，停止读取文件
Stop thread on EOF? --- 当Recycle on EOF为False时，当读取文件到结尾时，停止进程，当Recycle on EOF为True时，此项无意义
```

备注说明：这里我用通俗的语言大概讲一下Recycle on EOF与Stop thread on EOF结果的关联
```
Recycle on EOF ：到了文件尾处，是否循环读取参数，选项：true和false
Stop thread on EOF：到了文件尾处，是否停止线程，选项：true和false
当Recycle on EOF 选择true时，Stop thread on EOF选择true和false无任何意义，通俗的讲，在前面控制了不停的循环读取，后面再来让stop或run没有任何意义
当Recycle on EOF 选择flase时，Stop thread on EOF选择true，线程4个，参数3个，那么只会请求3次
当Recycle on EOF 选择flase时，Stop thread on EOF选择flase，线程4个，参数3个，那么会请求4次，但第4次没有参数可取，不让循环，所以第4次请求错误
```

#### b、使用刚才定义好的变量

![](./images/Jmeter_06_06.png)

至此，两种参数化的方法就介绍完了。

需要说明一下：函数助手方法要比CSV控件方法参数化功能要弱，推荐使用CSV控件方法。

再看看与loadrunner参数化不一样的：

1. jmeter参数文件的第一行没有列名称
2. 这里要注意的是参数文件的编码，可以使用记事本另存为就可以修改该编码（编码问题在使用CSV Data Set Config参数化时要求的比较严格）
3. Jmeter的参数化设置没有LoadRunner做的出色，它是依赖于线程设置的（只有CSV Data Set Config参数化方法才有）