# Java之voliate,synchronized,AtomicInteger使用

## 1.voliate 

用在多线程，同步变量。 线程为了提高效率，将成员变量(如A)某拷贝了一份（如B），线程中对A的访问其实访问的是B。只在某些动作时才进行A和B的同步。因此存在A和B不一致的情况。volatile就是用来避免这种情况的。volatile告诉jvm， 它所修饰的变量不保留拷贝，直接访问主内存中的（也就是上面说的A) ，但是不能用其来进行多线程同步控制

```
public class Counter {
public volatile  static int count = 0;
public static void inc() {
//这里延迟5毫秒，使得结果明显
try {
Thread.sleep(5);
} catch (InterruptedException e) {
}
//synchronized(Counter.class) {
count ++;
//}
}
public static void main(String[] args) throws InterruptedException {
final CountDownLatch latch = new CountDownLatch(1000);
//同时启动1000个线程，去进行i++计算，看看实际结果
for (int i = 0; i < 1000; i++) {
new Thread(new Runnable() {
@Override
public void run() {
Counter.inc();
latch.countDown();
}
}).start();
}
latch.await();
//这里每次运行的值都有可能不同,可能为1000
System.out.println("运行结果:Counter.count=" + Counter.count);
}
}
```
可以看到，运行结果:Counter.count=929（数字随机），但如果将注释掉的同步块synchronized打开，console输出则为1000

## 2.synchronized

它用来修饰一个方法或者一个代码块的时候，能够保证在同一时刻最多只有一个线程执行该段代码。
- 一、当两个并发线程访问同一个对象object中的这个synchronized(this)同步代码块时，一个时间内只能有一个线程得到执行。另一个线程必须等待当前线程执行完这个代码块以后才能执行该代码块。
- 二、然而，当一个线程访问object的一个synchronized(this)同步代码块时，另一个线程仍然可以访问该object中的非synchronized(this)同步代码块。
- 三、尤其关键的是，当一个线程访问object的一个synchronized(this)同步代码块时，其他线程对object中所有其它synchronized(this)同步代码块的访问将被阻塞。
- 四、第三个例子同样适用其它同步代码块。也就是说，当一个线程访问object的一个synchronized(this)同步代码块时，它就获得了这个object的对象锁。结果，其它线程对该object对象所有同步代码部分的访问都被暂时阻塞。
- 五、以上规则对其它对象锁同样适用.
## 3.AtomicInteger
使用AtomicInteger，即使不用同步块synchronized，最后的结果也是1000，可用看出AtomicInteger的作用，用原子方式更新的int值。主要用于在高并发环境下的高效程序处理。使用非阻塞算法来实现并发控制。
```
public class Counter {
public  static AtomicInteger count = new AtomicInteger(0);
public static void inc() {
//这里延迟1毫秒，使得结果明显
try {
Thread.sleep(1);
} catch (InterruptedException e) {
}
count.getAndIncrement();
}
public static void main(String[] args) throws InterruptedException {
final CountDownLatch latch = new CountDownLatch(1000);
//同时启动1000个线程，去进行i++计算，看看实际结果
for (int i = 0; i < 1000; i++) {
new Thread(new Runnable() {
@Override
public void run() {
Counter.inc();
latch.countDown();
}
}).start();
}
latch.await();
//这里每次运行的值都有可能不同,可能为1000
System.out.println("运行结果:Counter.count=" + Counter.count);
}
}
```