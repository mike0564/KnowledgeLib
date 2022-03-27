# Gitbook安装

## 一、安装nodejs
下载地址：https://nodejs.org/download/release/v10.23.0/
注意不要下载最新版本，否则会出现其他报错，在使用的过程中，如果遇到异常报错，尝试更换nodejs版本。
安装成功之后输入`node -v`，显示node.js版本代表安装成功。
## 二、安装Gitbook
```
npm install gitbook -g
sudo npm install gitbook -g
```

一定要用到`-g`，这个代表全局安装，我去掉`-g`安装了一次，也成功了，但是在终端使用`gitbook -V`查看的时候发现根本没安装

在终端输入`gitbook -V`之后即可查看当前Gitbook版本，代表安装成功。需要注意的是“V”一定要大写。

## 三、使用Gitbook
1）新建目录gitbook，用于存放gitbook文件
2）初始化gitbook
进入gitbook目录，执行初始化命令：
```
gitbook init
```
自动在gitbook目录下生成README.md文件和SUMMARY.md文件；
4）安装gitbook插件
```
gitbook install
```
3）启动gitbook
执行启动命令：
```
gitbook serve
```
gitbook启动后，会生成浏览器访问的地址，可通过浏览器访问gitbook内容，默认为：http://localhost:4000
## 四、安装calibre插件
calibre是一款非常方便的开源电子书转换软件。在这里，我们也是用到ebook-convert这个插件。
首先在calibre官网下载插件，下载链接：https://calibre-ebook.com/download
下载适合自己系统的版本。
将安装的calibre放在系统应用中，然后将app添加到path中。

执行一个命令`sudo ln -s /Applications/calibre.app/Contents/MacOS/ebook-convert /usr/local/bin`

使用命令`gitbook pdf . KnowledgeLib.pdf`生成pdf文件

