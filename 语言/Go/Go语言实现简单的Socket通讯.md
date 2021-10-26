# Go语言实现简单的Socket通讯

## 说明
### 什么是socket

Socket起源于Unix，而Unix基本哲学之一就是“一切皆文件”，都可以用“打开open –> 读写write/read –> 关闭close”模式来操作。Socket就是该模式的一个实现，网络的Socket数据传输是一种特殊的I/O，Socket也是一种文件描述符。Socket也具有一个类似于打开文件的函数调用：Socket()，该函数返回一个整型的Socket描述符，随后的连接建立、数据传输等操作都是通过该Socket实现的。

常用的Socket类型有两种：流式Socket（SOCK_STREAM）和数据报式Socket（SOCK_DGRAM）。流式是一种面向连接的Socket，针对于面向连接的TCP服务应用；数据报式Socket是一种无连接的Socket，对应于无连接的UDP服务应用。

### socket种类

Socket有两种：TCP Socket和UDP Socket，TCP和UDP是协议，而要确定一个进程的需要三元组，需要IP地址、协议和端口，具体看下面示例部分。

## 实现
### tcp socket
#### tcp socket Server端

```go
package main

import (
    "bufio"
    "fmt"
    "net"
)

func process(conn net.Conn) {
    // 5. 定义defer关闭连接
    defer conn.Close() 
    // 6.无限循环
    for {
        // 7.创建一个带缓存的读读取对象，读取tcp连接里的内容
        reader := bufio.NewReader(conn)
        // 8.定义一个128字节的数组
        var buf [128]byte
        // 9.调用从当前tcp连接里读取内容的对象的Read方法将从tcp里读取的数据存入buf[:]切片里，有两个返回值，一个是读取数据总数，另一个是报错
        n, err := reader.Read(buf[:])
        if err != nil {    // 处理报错
            fmt.Println("read data error:", err)
            break
        }
        // 10.打印切片里的内容（下标从0到读取的总数）
        fmt.Printf(string(buf[0:n]))
        // 11.回复客户端消息（发送的消息一定要是byte类型的切片）     
        conn.Write([]byte("Welcome to Golang")) 
    }

}


func main() {
    // 1.调用net包下的Listen()方法启动tcp的端口监听
    listen, err := net.Listen("tcp", "0.0.0.0:8088") 
    if err != nil {                                  // 判断是否有错误
        fmt.Println("listen failed error", err)
        return
    }

    // 2.无限循环，处理请求
    for { 
        // 3.等待链接（没有客户端连接时在这里阻塞，有客户端连接时处理连接）
        conn, err := listen.Accept()
        if err != nil {              // 判断错误（打印错误，退出当前循环进入下次循环）
            fmt.Println("accept failed err", err)
            continue
        }
        // 4.启动一个携程处理连接
        go process(conn) // 5.启用一个goroutine处理当前的连接
    }

}
```
#### tcp socket Client端
```go
package main

import (
    "fmt"
    "net"
    "bufio"
    "os"
    "strings"
)


func main() {
    // 1.调用net.Dial()方法以tcp协议的方式连接localhost的8088端口
    conn, err := net.Dial("tcp","localhost:8088")
    if err != nil {     // 判断错误
        fmt.Println("Error dialing",err.Error())
        return
    }
    // 2.定义defer，在结束时关闭连接
    defer conn.Close()     

    // 3.从标准输入里创建一个读的对象
    inputReader := bufio.NewReader(os.Stdin)     
    // 4.无限循环
    for {
        // 5.调用读的对象的ReadString方法判断，如果有'\n'（也就是换行符）就认为输入结束了，返回两个值，一个是字符串，另一个是报错
        input, _ := inputReader.ReadString('\n')
        // 6.利用strings.Trim方法给要发送的数据去掉空格
        trimmedInput := strings.Trim(input,"\r\n")
        // 7.如果输入内容是q就退出了
        if trimmedInput == "Q" {      
            return
        }
        // 8.发送数据，发送的数据必须要是byte类型的切片，返回值是发送的总数据和错误
        _, err = conn.Write([]byte(trimmedInput))      
        if err != nil {     // 错误处理
            return
        }
        // 9.读取服务端发来的消息
        var buf [1024]byte
        n, err := conn.Read(buf[:])    // 获取到一个读取的总数量和错误
        if err != nil {
            fmt.Println("read server data err", err)
            return
        }
        // 10.打印服务端返回的消息
        fmt.Println(string(buf[:n]))


    }
}
```
### udp socket
#### udp socket Server端
```go
package main

import (
    "net"
    "fmt"
)

func main() {
    // 1.使用net.ListenUDP()启动一个UDP的监听
    listen, err := net.ListenUDP("udp", &net.UDPAddr{
        IP:   net.IPv4(0, 0, 0, 0),
        Port: 30000,
    })
    if err != nil {       // 判断错误
        fmt.Println("listen failed, err:", err)
        return
    }
    // 2.使用defer关闭连接
    defer listen.Close()
    // 3.无限循环
    for {
        // 4.定义存储从连接里读取消息的变量
        var data [1024]byte
        // 5.从udp连接里读取消息到data变量里,返回值有：接收的数据总数量，谁发过来的数据，错误
        n, addr, err := listen.ReadFromUDP(data[:])
        if err != nil {         // 错误处理
            fmt.Println("read udp failed, err:", err)
            continue
        }
        // 6.打印接收到的消息、发消息的地址和消息长度
        fmt.Printf("data:%v addr:%v count:%v\n", string(data[:n]), addr, n)
        // 7.给客户端返回消息，谁发过来的消息就返回给谁，接收到的消息时什么就返回什么消息
        _, err = listen.WriteToUDP(data[:n], addr)
        if err != nil {          // 错误处理
            fmt.Println("write to udp failed, err:", err)
            continue
        }
    }
}
```

#### udp socket Client端
```go
package main

import (
    "net"
    "fmt"
    "os"
    "bufio"
)

func main() {
    // 1.调用net.DialUDP()方法以udp协议连接到0.0.0.0:30000地址
    socket, err := net.DialUDP("udp", nil, &net.UDPAddr{
        IP:   net.IPv4(0, 0, 0, 0),
        Port: 30000,
    })
    if err != nil {      // 错误处理
        fmt.Println("连接服务端失败，err:", err)
        return
    }
    // 2.定义defer关闭连接
    defer socket.Close()
    // 3.无限循环
    for {
        // 4.实例化从终端输入对象
        input := bufio.NewReader(os.Stdin)
        // 5.没有输入内容时会等待，输入的内容遇到'\n'就认为输入结束，进入下一次循环。
        s, _ := input.ReadString('\n')   
        // 6.发送数据，发送的数据必须转为byte类型的切片
        _, err = socket.Write([]byte(s))
        if err != nil {       // 判断错误
            fmt.Println("发送数据失败，err:", err)
            return
        }
        // 7.定义存储服务端返回消息的变量
        data := make([]byte, 4096)
        // 8.接收服务端返回的消息存储到变量data里，返回值有：接收数据的总大小，谁发来的，错误
        n, remoteAddr, err := socket.ReadFromUDP(data)
        if err != nil {       // 判断错误
            fmt.Println("接收数据失败，err:", err)
            return
        }
        // 打印接收到的数据
        fmt.Printf("recv:%v addr:%v count:%v\n", string(data[:n]), remoteAddr, n)    
    }
    
}
```

### tcp请求百度
```go
package main

import (
    "fmt"
    "net"
    "io"
)

func main() {
    conn, err := net.Dial("tcp","www.baidu.com:80")
    if err != nil {
        fmt.Println("Error dialing",err.Error())
        return
    }
    defer conn.Close()
    msg := "GET / HTTP/1.1\r\n"
    msg += "Host: www.baidu.com\r\n"
    msg += "Connection: close\r\n"
    msg += "\r\n\r\n"

    _, err = io.WriteString(conn, msg)
    if err != nil {
        fmt.Println("write string failed",err)
        return
    }
    buf := make([]byte,4096)
    for {
        count, err := conn.Read(buf)
        if err != nil {
            break
        }
        fmt.Println(string(buf[0:count]))
    }
}
```
## tcp socket粘包问题解决

说明：
　　一般所谓的TCP粘包是在一次接收数据不能完全地体现一个完整的消息数据。TCP通讯为何存在粘包呢？主要原因是TCP是以流的方式来处理数据，再加上网络上MTU的往往小于在应用处理的消息数据，所以就会引发一次接收的数据无法满足消息的需要，导致粘包的存在。处理粘包的唯一方法就是制定应用层的数据通讯协议，通过协议来规范现有接收的数据是否满足消息数据的需要。在应用中处理粘包的基础方法主要有两种分别是以4节字描述消息大小或以结束符，实际上也有两者相结合的如HTTP,redis的通讯协议等。
　　
示例：

### Server端
```go
package main

import (
    "bufio"
    "fmt"
    "encoding/binary"
    "io"
    "net"
    "bytes"
)

func Decode(reader *bufio.Reader) (string, error) {
    // 9.读取接收到消息的前四个字节获取本次接收的消息长度，Peek读取消息时不移动读取位置
    lengthByte, _ := reader.Peek(4)

    // 10.bytes.NewBuffer：从一个切片构造一个buffer（缓冲区）
    lengthBuff := bytes.NewBuffer(lengthByte)
    // 11.定义一个int32类型的变量存储要读取消息的长度
    var length int32
    // 12.读取lengthBuff变量里的数据存到length变量里，此时length的值是要从连接里读取数据的长度
    err := binary.Read(lengthBuff, binary.LittleEndian, &length)
    if err != nil {      // 错误处理
        return "", err
    }
    // 13.如果缓冲里的数据没有要读取的数据长就返回错误信息
    if int32(reader.Buffered()) < length+4 {
        return "", err
    }

    // 14.定义一个要读取数据长度+4的byte类型切片变量
    pack := make([]byte, int(4+length))
    // 15.将从连接里读取的消息存入pack变量里（即每次从连接里读取 “int(4+length)”长度的数据）
    _, err = reader.Read(pack)
    if err != nil {      // 错误处理
        return "", err
    }
    // 16.返回从连接里读取的数据（前四个是读取消息的长度（不返回），只返回下标4之后的内容）
    return string(pack[4:]), nil
}

func process(conn net.Conn) {
    // 5.定义defer关闭连接
    defer conn.Close()
    // 6.实例化一个从当前连接里读取消息的对象
    reader := bufio.NewReader(conn)
    // 7.无限循环
    for {
        // 8.将读取消息的对象给Decode函数解码，返回值是从连接里读取到的消息和错误提示
        msg, err := Decode(reader)
        // 17.判断错误，读取到结尾错误和其他错误    
        if err == io.EOF {
            return
        }
        if err != nil {
            fmt.Println("decode msg failed, err:", err)
            return
        }
        // 18.最终将客户端发来的消息打印出来
        fmt.Println("收到client发来的数据：", msg)
    }
}

func main() {
    // 1.启动 tcp协议的监听
    listen, err := net.Listen("tcp", "127.0.0.1:30000")
    if err != nil {         // 错误判断
        fmt.Println("listen failed, err:", err)
        return
    }
    defer listen.Close()       // 定义defer关闭连接
    // 2.无限循环
    for {
        // 3.等待客户端连接（无连接时会阻塞，有连接时自动处理连接）
        conn, err := listen.Accept()
        if err != nil {      // 错误处理
            fmt.Println("accept failed, err:", err)
            continue
        }
        // 4.启动一个携程，将连接传给携程处理
        go process(conn)
    }
}
```
### Client端
```go
package main

import (
    "fmt"
    "net"
)

func Encode(message string) ([]byte, error) {
    // 6.读取消息的长度，转换成int32类型（占4个字节）
    var length = int32(len(message))
    // 7.定义缓冲区变量
    var pkg = new(bytes.Buffer)
    // 8.往缓冲区变量里写入消息的长度(binary.LittleEndian：按照小端写入的方式写入（百度搜大小端读写了解相关内容）)
    err := binary.Write(pkg, binary.LittleEndian, length)
    if err != nil {        // 错误处理
        return nil, err
    }
    // 9.往缓冲区变量里写入消息实体
    err = binary.Write(pkg, binary.LittleEndian, []byte(message))
    if err != nil {       // 错误处理
        return nil, err
    }
    // 10.返回缓冲区里的所有字节和错误信息
    return pkg.Bytes(), nil
}

func main() {
    // 1.建立拨号连接连接服务端
    conn, err := net.Dial("tcp", "127.0.0.1:30000")
    if err != nil {      // 错误处理
        fmt.Println("dial failed, err", err)
        return
    }
    // 2.定义defer关闭连接
    defer conn.Close()
    // 3.循环20次
    for i := 0; i < 20; i++ {
        // 4.定义要发送消息内容
        msg := `Hello, Hello. How are you?`
        // 5.将要发送的消息传给Encode函数进行编码
        data, err := Encode(msg)
        if err != nil {      // 错误处理
            fmt.Println("encode msg failed, err:", err)
            return
        }
        // 11.往连接里写入编码后的数据
        conn.Write(data)
    }
}
```