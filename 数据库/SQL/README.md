# SQL

SQL 是用于访问和处理数据库的标准的计算机语言。

## 什么是 SQL？
- SQL 指结构化查询语言
- SQL 使我们有能力访问数据库
- SQL 是一种 ANSI 的标准计算机语言
注：ANSI，美国国家标准化组织

## SQL 能做什么？
- SQL 面向数据库执行查询
- SQL 可从数据库取回数据
- SQL 可在数据库中插入新的记录
- SQL 可更新数据库中的数据
- SQL 可从数据库删除记录
- SQL 可创建新数据库
- SQL 可在数据库中创建新表
- SQL 可在数据库中创建存储过程
- SQL 可在数据库中创建视图
- SQL 可以设置表、存储过程和视图的权限

## SQL 是一种标准 - 但是...
SQL 是一门 ANSI 的标准计算机语言，用来访问和操作数据库系统。SQL 语句用于取回和更新数据库中的数据。SQL 可与数据库程序协同工作，比如 MS Access、DB2、Informix、MS SQL Server、Oracle、Sybase 以及其他数据库系统。

不幸地是，存在着很多不同版本的 SQL 语言，但是为了与 ANSI 标准相兼容，它们必须以相似的方式共同地来支持一些主要的关键词（比如 SELECT、UPDATE、DELETE、INSERT、WHERE 等等）。

注释：除了 SQL 标准之外，大部分 SQL 数据库程序都拥有它们自己的私有扩展！

## 在您的网站中使用 SQL
要创建发布数据库中数据的网站，您需要以下要素：
- RDBMS 数据库程序（比如 MS Access, SQL Server, MySQL）
- 服务器端脚本语言（比如 PHP 或 ASP）
- SQL
- HTML/CSS

## RDBMS
RDBMS 指的是关系型数据库管理系统。

RDBMS 是 SQL 的基础，同样也是所有现代数据库系统的基础，比如 MS SQL Server, IBM DB2, Oracle, MySQL 以及 Microsoft Access。

RDBMS 中的数据存储在被称为表（tables）的数据库对象中。

表是相关的数据项的集合，它由列和行组成。

## 数据库表
一个数据库通常包含一个或多个表。每个表由一个名字标识（例如“客户”或者“订单”）。表包含带有数据的记录（行）。

下面的例子是一个名为 "Persons" 的表：
<table class="dataintable">
<tbody>
<tr>
<th>Id</th>
<th>LastName</th>
<th>FirstName</th>
<th>Address</th>
<th>City</th>
</tr>
<tr>
<td>1</td>
<td>Adams</td>
<td>John</td>
<td>Oxford Street</td>
<td>London</td>
</tr>
<tr>
<td>2</td>
<td>Bush</td>
<td>George</td>
<td>Fifth Avenue</td>
<td>New York </td>
</tr>
<tr>
<td>3</td>
<td>Carter</td>
<td>Thomas</td>
<td>Changan Street</td>
<td>Beijing</td>
</tr>
</tbody></table>
上面的表包含三条记录（每一条对应一个人）和五个列（Id、姓、名、地址和城市）。

## SQL 语句
您需要在数据库上执行的大部分工作都由 SQL 语句完成。
下面的语句从表中选取 LastName 列的数据：
```sql
SELECT LastName FROM Persons
```
## 重要事项
<p style="color:red;">一定要记住，SQL 对大小写不敏感！</p>

## SQL 语句后面的分号？
某些数据库系统要求在每条 SQL 命令的末端使用分号。

分号是在数据库系统中分隔每条 SQL 语句的标准方法，这样就可以在对服务器的相同请求中执行一条以上的语句。

如果您使用的是 MS Access 和 SQL Server 2000，则不必在每条 SQL 语句之后使用分号，不过某些数据库软件要求必须使用分号。

## SQL DML 和 DDL
可以把 SQL 分为两个部分：数据操作语言 (DML) 和 数据定义语言 (DDL)。

SQL (结构化查询语言)是用于执行查询的语法。但是 SQL 语言也包含用于更新、插入和删除记录的语法。

查询和更新指令构成了 SQL 的 DML 部分：

- SELECT - 从数据库表中获取数据
- UPDATE - 更新数据库表中的数据
- DELETE - 从数据库表中删除数据
- INSERT INTO - 向数据库表中插入数据

SQL 的数据定义语言 (DDL) 部分使我们有能力创建或删除表格。我们也可以定义索引（键），规定表之间的链接，以及施加表间的约束。

SQL 中最重要的 DDL 语句:

- CREATE DATABASE - 创建新数据库
- ALTER DATABASE - 修改数据库
- CREATE TABLE - 创建新表
- ALTER TABLE - 变更（改变）数据库表
- DROP TABLE - 删除表
- CREATE INDEX - 创建索引（搜索键）
- DROP INDEX - 删除索引

