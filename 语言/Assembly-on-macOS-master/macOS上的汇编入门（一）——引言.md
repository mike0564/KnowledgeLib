我最近一个阶段都在学习汇编语言，但是，当我想使用我的Mac编写汇编语言的时候，发现了许多问题。比如说，大多数实体的教材都采用的是32位甚至是16位的处理器，在如今仅支持64位架构的macOS 10.15上根本不能原生运行；再者，基于XNU这种类Unix内核的macOS系统，汇编语言的部分细节，如系统调用号等等与Linux不同，调用约定也与Windows不同。但现在网络上基于macOS来入门汇编语言的文章非常少，涉及到macOS汇编的也基本上不是用来入门的文章。因此，我打算利用这个暑假来写一写如何在macOS上入门汇编语言。

#  需要的背景知识

阅读我写的这一系列文章需要的背景知识并不多，包括：

* 能看懂C语言
* 一点点的计组知识
* 一点点的命令行知识（至少应当会在终端下进入指定的目录）

# 这系列文章究竟讲了什么

那么，我打算讲的是在macOS上利用GAS语法，也就是AT&T语法进行x86-64汇编的入门。

下一篇文章：[macOS上的汇编入门（二）——数学基础](macOS上的汇编入门（二）——数学基础.md)