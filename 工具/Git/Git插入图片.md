# Git插入图片

## 使用绝对路径添加图片

1. 将图片文件拷贝到本地仓库目录下，执行

    git add *

    git commit

    git push -u origin master

2. 查看上传的图片url

3. 在要引用的md文件中插入代码

    \!\[image](url)

## 使用相对路径插入图片

1. 在本地仓库md文件的同目录下创建images文件夹，将图片放至上述文件夹中，步骤同上。

2. 在md文件中引用时使用相对路径。

    \!\[](./image/*.png)
    
    相同路径用./表示，上级目录用../表示

注意：存放图片的文件夹或者图片名中含有空格或其他特殊字符，会导致图片无法加载，以下两种方案解决：

1.文件夹以及图片命名中不要用到空格和特殊字符

2.将相对路径进行URL编码，URL编码链接http://tool.oschina.net/encode?type=4

如果想改变图片的尺寸，可以通过代码标签

\.<img src="url" width="300" height="450" />

如果想改变图片居中

\.<div align=center><img src="url" width="300" height="450" /></div>
