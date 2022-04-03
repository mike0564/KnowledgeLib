# Homebrew更换国内镜像源

## 查看当前Homebrew镜像源

```
# brew.git镜像源
git -C "$(brew --repo)" remote -v
# homebrew-core.git镜像源
git -C "$(brew --repo homebrew/core)" remote -v
# homebrew-cask.git镜像源
git -C "$(brew --repo homebrew/cask)" remote -v 
```

## 国内镜像地址

- 科大: https://mirrors.ustc.edu.cn
- 阿里: https://mirrors.aliyun.com/homebrew/

## 修改为科大镜像源

```
git -C "$(brew --repo)" remote set-url origin https://mirrors.ustc.edu.cn/brew.git
git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
if [ $SHELL = "/bin/bash" ] # 如果你的是bash
then 
    echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles/' >> ~/.bash_profile
    source ~/.bash_profile
elif [ $SHELL = "/bin/zsh" ] # 如果用的shell 是zsh 的话
then
    echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles/' >> ~/.zshrc
    source ~/.zshrc
fi
brew update
```

## 恢复原有镜像源

```
git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git
# 找到 ~/.bash_profile 或者 ~/.zshrc 中的HOMEBREW_BOTTLE_DOMAIN 一行删除
brew update
```

## 如果不行的话可以依次尝试以下命令

```
brew doctor
brew update-reset
brew update
```

## 关闭brew每次打开时的自动更新

当我们在mac下使用brew安装软件时，默认每次都会自动更新homebrew，显示
Updating Homebrew...，网络状况不好或者没有换源的时候，很慢，会卡在这里许久不动。
我们可以关闭自动更新，在命令行执行：


```
export HOMEBREW_NO_AUTO_UPDATE=true
```

如果想要重启后设置依然生效，可以把上面这行加入到当前正在使用的shell的配置文件中，比如我正在使用的是zsh，那么执行以下语句：

`vi ~/.zshrc`

然后在合适的位置，加入上面那一行配置。