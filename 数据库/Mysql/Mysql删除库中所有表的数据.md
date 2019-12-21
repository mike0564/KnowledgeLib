# Mysql删除库中所有表的数据

MySQL 用 truncate 命令快速清空一个数据库中的所有表。

1. 先执行select语句生成所有truncate语句

语句格式：

```
select CONCAT('truncate TABLE ',table_schema,'.',TABLE_NAME, ';') from INFORMATION_SCHEMA.TABLES where  table_schema in ('数据库1','数据库2');
select CONCAT('truncate TABLE ',table_schema,'.',TABLE_NAME, ';') from INFORMATION_SCHEMA.TABLES where  table_schema like '%_abc';
```
2.整理得到的truncate语句，然后复制truncate语句到mysql命令行执行

复制truncate语句到mysql命令行执行，可以一次复制多条执行。

mysql> truncate TABLE dbname.ZONESERVICE;     

Query OK, 0 rows affected