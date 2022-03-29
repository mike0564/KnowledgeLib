# Docker常用命令

## 基础命令
### 启动docker
```shell
systemctl start docker
```
### 关闭docker
```shell
systemctl stop docker
```
### 重启docker
```shell
systemctl restart docker
```
### docker设置随服务启动而自启动
```shell
systemctl enable docker
```
### 查看docker 运行状态
```shell
systemctl status docker
```
### 查看docker 版本号信息
```shell
docker version
Client:
 Cloud integration: 1.0.17
 Version:           20.10.8
 API version:       1.41
 Go version:        go1.16.6
 Git commit:        3967b7d
 Built:             Fri Jul 30 19:58:50 2021
 OS/Arch:           windows/amd64
 Context:           default
 Experimental:      true

Server: Docker Engine - Community
 Engine:
  Version:          20.10.8
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.16.6
  Git commit:       75249d8
  Built:            Fri Jul 30 19:52:10 2021
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.4.9
  GitCommit:        e25210fe30a0a703442421b0f60afac609f950a3
 runc:
  Version:          1.0.1
  GitCommit:        v1.0.1-0-g4144b63
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```
```shell
docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Build with BuildKit (Docker Inc., v0.6.1-docker)
  compose: Docker Compose (Docker Inc., v2.0.0-rc.1)
  scan: Docker Scan (Docker Inc., v0.8.0)

Server:
 Containers: 7
  Running: 3
  Paused: 0
  Stopped: 4
 Images: 11
 Server Version: 20.10.8
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: e25210fe30a0a703442421b0f60afac609f950a3
 runc version: v1.0.1-0-g4144b63
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 5.4.72-microsoft-standard-WSL2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 16
 Total Memory: 12.02GiB
 Name: docker-desktop
 ID: G5Y7:RJTT:EOYK:JZZV:5ACO:ZWWM:6B6H:DWQ7:5OV2:N5JG:BDBE:VZNJ
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Registry Mirrors:
  https://4jon48pp.mirror.aliyuncs.com/
 Live Restore Enabled: false
```
### docker 帮助命令
```shell
docker --help
Usage:  docker [OPTIONS] COMMAND
A self-sufficient runtime for containers
Options:
      --config string      Location of client config files
  -c, --context string     Name of the context to use to connect to the
                           daemon (overrides DOCKER_HOST env var and
                           default context set with "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level
                           ("debug"|"info"|"warn"|"error"|"fatal")
                           (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA
      --tlscert string     Path to TLS certificate file
      --tlskey string      Path to TLS key file 
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit
Management Commands:
  builder     Manage builds
  buildx*     Build with BuildKit (Docker Inc., v0.6.1-docker)
  compose*    Docker Compose (Docker Inc., v2.0.0-rc.1)
  config      Manage Docker configs
  container   Manage containers
  context     Manage contexts
  image       Manage images
  manifest    Manage Docker image manifests and manifest lists
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  scan*       Docker Scan (Docker Inc., v0.8.0)
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes
Commands:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes
Run 'docker COMMAND --help' for more information on a command.
To get more help with docker, check out our guides at https://docs.docker.com/go/guides/
```
```shell
docker pull --help

Usage:  docker pull [OPTIONS] NAME[:TAG|@DIGEST]

Pull an image or a repository from a registry

Options:
  -a, --all-tags                Download all tagged images in the repository
      --disable-content-trust   Skip image verification (default true)
      --platform string         Set platform if server is multi-platform
                                capable
  -q, --quiet                   Suppress verbose output
```

## 镜像命令
### 查看自己服务器中docker 镜像列表

```shell
docker images
REPOSITORY                                            TAG                                                     IMAGE ID       CREATED         SIZE
redis                                                 latest                                                  7faaec683238   4 months ago    113MB
nacos/nacos-server                                    2.0.3                                                   433eb51fef8d   6 months ago    1.05GB
docker/desktop-kubernetes                             kubernetes-v1.21.3-cni-v0.8.5-critools-v1.17.0-debian   4c3740f7297c   6 months ago    299MB
registry.cn-hangzhou.aliyuncs.com/forcecop/forcecop   v1.0.0                                                  0bdccc5f76a6   8 months ago    1.82GB
docker/desktop-kubernetes                             kubernetes-v1.21.1-cni-v0.8.5-critools-v1.17.0-debian   e94f03666724   9 months ago    302MB
mysql                                                 5.6                                                     e26066fd423a   10 months ago   303MB
docker/desktop-kubernetes                             kubernetes-v1.19.7-cni-v0.8.5-critools-v1.17.0-debian   93b3398dbfde   12 months ago   285MB
chaosbladeio/chaosblade-demo                          latest                                                  1ef4d7419cfb   2 years ago     247MB
jplock/zookeeper                                      3.4.11                                                  6b454cf5e33c   3 years ago     146MB
riveryang/dubbo-admin                                 latest                                                  f562b039f6af   5 years ago     195MB
jeromefromcn/dubbo-monitor                            latest                                                  42a956874c02   5 years ago     139MB
```
### 搜索镜像
```shell
docker search 镜像名
docker search --filter=STARS=9000 mysql 搜索 STARS >9000的 mysql 镜像
NAME      DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
mysql     MySQL is a widely used, open-source relation…   12090     [OK]
```
### 拉取镜像
不加tag(版本号) 即拉取docker仓库中 该镜像的最新版本latest 加:tag 则是拉取指定版本
```shell
docker pull 镜像名 
docker pull 镜像名:tag
```
### 运行镜像
```shell
docker run 镜像名
docker run 镜像名:Tag
```
#### ex：
```shell
docker pull tomcat
docker run tomcat
```
发现出现tomcat 默认占用的8080 端口 说明该镜像已经是启动了 ，但是好像鼠标没有回到咱服务器上了 ，这怎么办呢 ？
使用Ctrl+C （注：此方式虽然可以退出容器，此命令是错误的，详细请见下文的容器命令）
docker中 run 命令是十分复杂的 有什么持久运行 映射端口 设置容器别名 数据卷挂载等
### 删除镜像
当前镜像没有被任何容器使用才可以删除
```shell
#删除一个
docker rmi -f 镜像名/镜像ID
#删除多个 其镜像ID或镜像用用空格隔开即可 
docker rmi -f 镜像名/镜像ID 镜像名/镜像ID 镜像名/镜像ID
#删除全部镜像  -a 意思为显示全部, -q 意思为只显示ID
docker rmi -f $(docker images -aq)
```
### 强制删除镜像
```shell
docker image rm 镜像名称/镜像ID
```
### 保存镜像
将镜像保存为tar压缩文件这样方便镜像转移和保存 ,然后可以在任何一台安装了docker的服务器上 加载这个镜像
```shell
docker save 镜像名/镜像ID -o 镜像保存在哪个位置与名字
```
#### exmaple:
```shell
docker save tomcat -o /myimg.tar
```
### 加载镜像
任何装 docker 的地方加载镜像保存文件,使其恢复为一个镜像
```shell
docker load -i 镜像保存文件位置
```
### 构建镜像
```
##（1）编写dockerfile
cd /docker/dockerfile
vim mycentos
##（2）构建docker镜像
docker build -f /docker/dockerfile/mycentos -t mycentos:1.1
```
## 容器命令
docker容器就好比java中的new出来对象（docker run 镜像产生一个该镜像具体容器实例）,docker 容器的启动需要镜像的支持
### 查看正在运行容器列表
```shell
docker ps
```
### 查看所有容器
包含正在运行 和已停止的
```shell
docker ps -a
```
### 容器端口与服务器端口映射
```shell
-p 宿主机端口:容器端口
docker run -itd --name redis002 -p 8888:6379 redis:5.0.5 /bin/bash
```
### 进入容器
```shell
docker exec -it 容器名/容器ID /bin/bash
docker exec -it redis /bin/bash
docker attach 容器名/容器ID
```
###  退出容器
```shell
#-----直接退出  未添加 -d(持久化运行容器) 时 执行此参数 容器会被关闭  
exit
# 优雅提出 --- 无论是否添加-d 参数 执行此命令容器都不会被关闭
Ctrl + p + q
```
### 停止容器
```shell
docker stop 容器ID/容器名
```
### 重启容器
```shell
docker restart 容器ID/容器名
```
### 启动容器
```shell
docker start 容器ID/容器名
```
### kill容器
```shell
docker kill 容器ID/容器名
```
### 容器文件拷贝
无论容器是否开启 都可以进行拷贝
```shell
#docker cp 容器ID/名称:文件路径  要拷贝到外部的路径   |     要拷贝到外部的路径  容器ID/名称:文件路径
#从容器内 拷出
docker cp 容器ID/名称: 容器内路径  容器外路径
#从外部 拷贝文件到容器内
docker  cp 容器外路径 容器ID/名称: 容器内路径
```
### 查看容器日志
```shell
docker logs -f --tail=要查看末尾多少行 默认all 容器ID
```
### 容器自启
启动容器时，使用docker run命令时 添加参数--restart=always便表示，该容器随docker服务启动而自动启动
```shell
docker run -itd --name redis002 -p 8888:6379 --restart=always  redis:5.0.5 /bin/bash
```
### 数据挂载
```shell
-v 宿主机文件存储位置:容器内文件位置
-v 宿主机文件存储位置:容器内文件位置 -v 宿主机文件存储位置:容器内文件位置 -v 宿主机文件存储位置:容器内文件位置

```
### 容器进程
```shell
##top支持 ps 命令参数，格式：docker top [OPTIONS] CONTAINER [ps OPTIONS]
##列出redis容器中运行进程
docker top redis
##查看所有运行容器的进程信息
for i in  `docker ps |grep Up|awk '{print $1}'`;do echo \ &&docker top $i; done
```
### 生成镜像
```shell
##基于当前redis容器创建一个新的镜像；参数：-a 提交的镜像作者；-c 使用Dockerfile指令来创建镜像；-m :提交时的说明文字；-p :在commit时，将容器暂停
docker commit -a="DeepInThought" -m="my redis" [redis容器ID]  myredis:v1.1
```
