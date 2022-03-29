# Git常见报错与解决方案

## 1.git添加远程库git remote add origin git@github.com:roboytim/zycfc_jmeter.git报错：“fatal: remote origin already exists.”

解决步骤：

1. 先删除	
`$ git remote rm origin`
2. 再次执行添加就可以了。

## 2.git push -u origin master报错“[rejected] master -> master (non-fast-forward)”

![](./images/error01.png)

解决步骤：

1. git pull origin master --allow-unrelated-histories //把远程仓库和本地同步，消除差异
2. 重新add和commit相应文件
```
git add filename
git commit -m "first commit"
```
3. git push origin master
4. 此时就能够上传成功了

## 3.pull遇到错误：error: Your local changes to the following files would be overwritten by merge:

解决步骤：
```
git stash  
git pull origin master  
git stash pop  

```
git stash的时候会把你本地快照，然后git pull 就不会阻止你了，pull完之后这时你的代码并没有保留你的修改。这时候执行git stash pop你去本地看会发现发生冲突的本地修改还在，这时候你该commit push啥的就悉听尊便了。

如果不想保留本地的修改，那好办。直接将本地的状态恢复到上一个commit id 。然后用远程的代码直接覆盖本地就好了。
```
git reset --hard 
git pull origin master
```
## 4.拉取代码时报错：error: The following untracked working tree files would be overwritten by merge

解决步骤：因为本地的文件跟远程库里的文件名相同，解决办法很简单，先使用命令：git clean -f  删除本地已存在的同名文件，然后再次 git pull 。

**相关命令：**

**git clean -f -n**：查看会删除哪些文件

**git clean -f**：删除上一条命令显示出来的文件

**git clean -fd**：删除文件夹

**git clean -fX**：删除已被忽略的文件

**git clean -fx**：删除已被忽略和未被忽略的文件


#### Git删除文件方法

##### 方法一：

步骤：

1. 在本地库中删除对应文件
2. 使用git status查看文件
![](./images/error02.png)
3. git rm filename,从版本库中删除文件
![](./images/error03.png)
4. git commit -m "remove filename"，提交确认删除
![](./images/error04.png)

##### 方法二：

步骤：
1. git init
2. cd “你的本地仓库地址”
3. git pull origin master	(#将远程仓库里面的项目拉下来)
4. dir	(#查看有哪些文件夹)
5. git rm -r --cached	“你要删除的文件名”
6. git commit -m 	'备注更改信息'
7. git push -u origin master 	（#更新状态）