# Windows通过ssh连接远程服务器

Windows CMD 命令行下输入ssh，报错'SSH' 不是内部或外部命令，也不是可运行的程序。

## 方法一：下载安装GIT
[GIT下载](https://git-scm.com/download/win)

cd ~/.ssh：进入c盘下的.ssh文件，如果文件不存在，则执行“mkdir ~/.ssh”新建文件

配置全局的name和email，这里是的你github或者bitbucket的name和email：
```
git config --global user.name "用户名"：
git config --global user.email "邮箱"
```
生成key：
```
ssh-keygen -t rsa -C"邮箱"
```
连接远程服务器：
```
ssh 用户名@远程服务器的ip地址
```
## 方法二：下载安装OpenSSH
[OpenSSH下载](https://github.com/PowerShell/Win32-OpenSSH/releases)

安装步骤：

1、进入链接下载最新 OpenSSH-Win64.zip（64位系统），解压至C:\Program Files\OpenSSH

2、打开cmd，cd进入C:\Program Files\OpenSSH（安装目录），执行命令：
```
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1
```
3、设置服务自动启动并启动服务：
```
sc config sshd start= auto
net start sshd
```
到此服务已经安装完毕，默认端口一样是22，默认用户名密码为Window账户名和密码，当然防火墙还是要设置对应端口允许通讯

修改设置：

通常linux下会修改ssh_config文件来修改ssh配置，但在安装目录并没有发现这个文件，查阅官方wiki后发现，原来是在C:\ProgramData\ssh目录下（此目录为隐藏目录）

端口号：Port 22

密钥访问：PubkeyAuthentication yes

密码访问：PasswordAuthentication no

空密码：PermitEmptyPasswords no

然后进入C:\Users\账户名\.ssh目录，创建authorized_keys公钥文件（也可在ssh_config修改路径）（仅限7.7之前版本，7.9版本请看最后更新）

设置完成后重启sshd服务，接下来就可以使用Xshell等工具使用密钥连接了~

*下载安装完成后，如果ssh命令仍然无法正常识别，请在Path中添加对应环境变量。*