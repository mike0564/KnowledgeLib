# Java中hashcode相等两个类一定相等吗

默认equals是比较地址，hashCode返回一个int的哈希码，equals判定为相同的，hashCode一定相同。equals判定为不同的，hashCode不一定不同，有可能相同。

"柳柴"与"柴柕"  hashCode=851553

"志捘"与"崇몈"  hashCode=786017

java中String.hashCode()方法的算法如下：
```
str.charAt(0) * 31n-1 + str.charAt(1) * 31n-2 + ... + str.charAt(n-1)
```
```
public class Test{
    public static void main(String [] args){
        List list=new ArrayList();
        list.add("a");
        list.add("b");
        list.add("a");
        Set set=new HashSet();
        set.add("a");
        set.add("b");
        set.add("a");
        System.out.println(list.size()+","+set.size());
    }
}
```
输出结果：3，2

道理很简单， ArrayList可以是插重复的内容， 而Set不可以插重复的内容(String重写了equals与hashCode方法)。

hashCode是所有java对象的固有方法，如果不重载的话，返回的实际上是该对象在jvm的堆上的内存地址，而不同对象的内存地址肯定不同，所以这个hashCode也就肯定不同了。如果重载了的话，由于采用的算法的问题，有可能导致两个不同对象的hashCode相同。

而且，还需要注意一下两点：

1）hashCode和equals两个方法是有语义关联的，它们需要满足：

A.equals(B)==true --> A.hashCode()==B.hashCode()

因此重载其中一个方法时也需要将另一个也重载。

2）hashCode的重载实现需要满足不变性，即一个object的hashCode不能前一会是1，过一会就变成2了。hashCode的重载实现最好依赖于对象中的final属性，从而在对象初始化构造后就不再变化。一方面是jvm便于代码优化，可以缓存这个hashCode；另一方面，在使用hashMap或hashSet的场景中，如果使用的key的hashCode会变化，将会导致bug，比如放进去时key.hashCode()=1，等到要取出来时key.hashCode()=2了，就会取不出来原先的数据。这个可以写一个简单的代码自己验证一下。

- 1.两个对象equals相等那么hashcode 是一定相等的。
- 2.两个对象equals不相等hashcode可能相等可以不相等。

因为hashCode说白了是地址值经过一系列的复杂运算得到的结果，而Object中的equals方法底层比较的就是地址值，所以equals()相等，hashCode必定相等，反equals()不等，在java底层进行哈希运算的时候有一定的几率出现相等的hashCode,所以hashCode（）可等可不等。
