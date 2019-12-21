# Loadrunner使用JDBC执行sql对数据库进行压测


```
import lrapi.lr;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
public class Actions
	{   
	private Connection conn=null;   
	private Statement stmt=null;   
	private ResultSet rs=null;   
	private String server="";//数据库地址  
	private String dataBase="";//数据库名
	private String username="system";//用户名
	private String password="123456";//密码
	private String url="jdbc:Oracle:thin:@192.168.127.129:1521:powerdes";
	public int init() throws Throwable{       
		//连接mysql数据库使用下面的方法
		//Class.forName("com.mysql.jdbc.Driver").newInstance();       
		//conn=DriverManager.getConnection("jdbc:mysql://"+server+"/dkhs?user="+username+"&password="+passworkd);
		//连接DB2数据库使用下面的方法
		Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();    
		conn=DriverManager.getConnection(url,username,password);
		stmt=conn.createStatement();       
		return 0;   
	}   
    public int action() throws Throwable{       
		rs=stmt.executeQuery("select * from test");       
		while(rs.next())
		{           
		    lr.error_message(rs.getString("ename")); //打印出查询的结果                  
		}       
		return 0;   
    }
    public int end() throws Throwable{       
		stmt.close();       
		conn.close();       
		return 0;   
    }
}

```