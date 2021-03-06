# 密码学之md5

## 题目：

Caesar 忘记了密码，从数据库中拿到md5——7d84fc037fa7d7bd53c88ecda36282c7，只想着明文是：flag{xxxx_hhh_passw0rd_xxxxx}这种格式，xxxx是1000-9999之内数字，xxxxx是20000-99999之间的数字

## 解题步骤：

还好，数字位数都不是很大，直接爆破：

```
import hashlib
import time
a = str(range(1000,9999))
b = str(range(20000,99999))
s = 'flag{'+a+'_hhh_passw0rd_'+b+'}'
start_time = time.time()
exitflag = False
for a in range(1000,9999):
    for b in range(20000,99999):
        s = 'flag{'+str(a)+'_hhh_passw0rd_'+str(b)+'}'
        s_md5 = hashlib.md5(s.encode()).hexdigest()
        print (s_md5)
        if(s_md5=='7d84fc037fa7d7bd53c88ecda36282c7'):
            end_time = time.time()
            print ('time:[%.3f]\tflag:[%s]' % ((end_time-start_time),s))
            exitflag = True
            break
    if exitflag:
        break
```
运行结果：
```
time:[403.076]	flag:[flag{1611_hhh_passw0rd_39802}]
```
## MD5

MD5是一个安全的散列算法，输入两个不同的明文不会得到相同的输出值，根据输出值，不能得到原始的明文，即其过程不可逆；所以要解密MD5没有现成的算法，只能用穷举法，把可能出现的明文，用MD5算法散列之后，把得到的散列值和原始的数据形成一个一对一的映射表，通过比在表中比破解密码的MD5算法散列值，通过匹配从映射表中找出破解密码所对应的原始明文。

对信息系统或者网站系统来说，MD5算法主要用在用户注册口令的加密，对于普通强度的口令加密，可以通过以下三种方式进行破解：
- （1）在线查询密码。一些在线的MD5值查询网站提供MD5密码值的查询，输入MD5密码值后，如果在数据库中存在，那么可以很快获取其密码值。
- （2）使用MD5破解工具。网络上有许多针对MD5破解的专用软件，通过设置字典来进行破解。
- （3）通过社会工程学来获取或者重新设置用户的口令。

### 1.下载文件时，经常看见的MD5 SHA1是干什么用的？

在人类社会中通常使用指纹作为一个人的特征，来识别或确认一个人的身份。但在计算机中如何确认或识别一个文件呢？没错，我们使用MD5值作为文件的指纹，来验证文件。

在计算机中，每个文件说白了都是一段保存在硬盘中的数据，因为不同文件保存在硬盘上的01序列不同，所以可以通过MD5这种算法，给这段很大的文件数据，算出一个128bit的值，这个值就叫MD5值，这样就实现了我文件的识别。(不管多长的数据，得到的都是128bit的值，所以MD5叫摘要算法，这个过程是不可逆的.)

发送方要给接收方发送一个文件，但是文件中途可能被人劫持并篡改替换掉，那接收方如何确认收到的文件就是发送方的发送的原始数据呢？

这时候发送方可以在发送文件时，跟接收方约定一个MD5，接收方接到文件后，计算文件的MD5值，如果得到的结果和发送方给的MD5值相同，就说明文件没有被替换篡改过。(类似功能的算法还有SHA系列)。

### 2.MD5值对应的输入值是唯一的吗？

已知原文abcdefg，它对应的MD5值为7AC66C0F148DE9519B8BD264312C4D64，

这里输入值是abcdefg，输出值是7AC66C0F148DE9519B8BD264312C4D64，

问题是世界上只有abcdefg的输出值是7AC66C0F148DE9519B8BD264312C4D64吗？

当然不是，理论上有无数种输入可以得到同一个MD5值，只是想在短时间内找到非常难。

### 3.MD5碰撞是什么意思?

两个不同输入，却得到同一个MD5，这两个输入值就算是碰撞。

### 4.什么是彩虹表？

123456的MD5值为E10ADC3949BA59ABBE56E057F20F883E，我们把123456这类经常出现的值全部算出md5值然后保存为一个巨大的表。当我们想知道某个MD5值的原文内容时，就可以把这个MD5值输入到表中去反向查询原文。

如果想再深入了解一下彩虹表，可以点击这里：

[Ophcrack彩虹表(Rainbow Tables)原理详解](http://www.ha97.com/4009.html)
