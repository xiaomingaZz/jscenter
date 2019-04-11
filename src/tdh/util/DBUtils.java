/**
 *
 *@author: sikem , create date: 2010-9-12
 *
 */

package tdh.util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import tdh.core.db.DataSourceManager;
import tdh.web.WebAppContext;

/**
 * 数据库的公用方法.
 * 
 * @author sikem
 * 
 */
public class DBUtils {

  /** log4j日志对象. */
  private static final Log MYLOG = LogFactory.getLog(DBUtils.class);

  
  /**
   * 主业务Connection
   * 
   * @return Connection
   * @author 仇国庆
   * @date 2013-2-25
   */
  public static synchronized Connection getBiConn() {
    return WebAppContext.getNewConn("bi09dataSource");
  }
  
  public static synchronized Connection getDpzsConn() {
    return getConn("dpzs", "jdbc.properties");
  }
  
  public static synchronized Connection getPortalConn() {
    return getConn("portal", "jdbc.properties");
  }

  
  public static synchronized Connection getSpxtConn() {
    return DataSourceManager.getInstnace().getConnection("SPXT", "spxt");
  }
  
  public static synchronized Connection getCkwConn() {
    // return getConn("ckw", "jdbc_ckw.properties");
    return DataSourceManager.getInstnace().getConnection("SFCK", "ckw");
  }
  
  public static synchronized Connection getCkwJzConn() {
    // return getConn("ckw", "jdbc_ckw.properties");
    return DataSourceManager.getInstnace().getConnection("SFCK", "ckwjz");
  }
  
  public static synchronized Connection getCkwSjjgConn() {
    // return getConn("ckw", "jdbc_ckw.properties");
    return DataSourceManager.getInstnace().getConnection("SFCK", "sjjg");
  }

  public static synchronized Connection getSjzxConn() {
    // return getConn("dbc", "jdbc_sjzx.properties");
    return DataSourceManager.getInstnace().getConnection("DBCS", "dbc");
  }

  public static synchronized Connection getSjzxDpzsConn() {
    return DataSourceManager.getInstnace().getConnection("DBCS", "dpzs");
    // return getConn("zxjc", "jdbc_sjzx.properties");
  }

  public static synchronized Connection getSsfkConn() {
    return DataSourceManager.getInstnace().getConnection("SSFK", "ssfk");
    // return getConn("ssfk", "jdbc_ssfk.properties");
  }

  public static synchronized Connection getSfjdConn() {
    // return getConn("sfjd", "jdbc_sfjd.properties");

    return DataSourceManager.getInstnace().getConnection("SFJD", "sfjd");
  }

  
  public static synchronized Connection getTbwConn() {
    // return getConn("sfjd", "jdbc_sfjd.properties");

    return DataSourceManager.getInstnace().getConnection("TBW", "tbw");
  }
  
  public static synchronized Connection getZxxfConn() {

    return DataSourceManager.getInstnace().getConnection("ZXXF", "zxxf");
  }

  
  public static synchronized Connection getConn(String jdbcName, String fName) {
    String driverClass = "";
    String url = "";
    String usr = "";
    String pwd = "";

    try {
      InputStream in = DBUtils.class.getClassLoader().getResourceAsStream("../config/" + fName);
      Properties p = new Properties();
      p.load(in);
      driverClass = p.getProperty(jdbcName + ".driverClassName");
      url = p.getProperty(jdbcName + ".url");
      usr = p.getProperty(jdbcName + ".username");
      pwd = p.getProperty(jdbcName + ".password");

      in.close();
    } catch (IOException e1) {
      e1.printStackTrace();
      return null;
    }

    Connection conn = null;
    try {
      Class.forName(driverClass);
    } catch (ClassNotFoundException e) {
      MYLOG.error(e);
    }
    try {
      conn = DriverManager.getConnection(url, usr, pwd);
    } catch (SQLException e) {
      e.printStackTrace();
      MYLOG.error(e);
    }
    return conn;
  }

  /**
   * 
   * @param url
   * @param usr
   * @param pwd
   * @param driverClass
   * @return
   */
  public static Connection getConn(String url, String usr, String pwd, String driverClass) {
    Connection conn = null;
    try {
      Class.forName(driverClass);
    } catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    try {
      conn = DriverManager.getConnection(url, usr, pwd);
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return conn;
  }

  /**
   * 关闭数据库资源.
   * 
   * @param conn
   *          Connection
   * @param pstmt
   *          PreparedStatement
   * @param st
   *          Statement
   * @param rs
   *          ResultSet 如果部分资源不存在，传入null
   */
  public static void close(Connection conn, Statement st, ResultSet rs) {
    closeRs(rs);
    closeSt(st);
    closeConn(conn);
  }

  public static void closeConn(Connection conn) {
    try {
      if (conn != null && !conn.isClosed()) {
        conn.close();
      }
    } catch (Exception e) {
      MYLOG.error(e);
    }
  }

  public static void closeSt(Statement st) {
    try {
      if (st != null) {
        st.close();
      }
    } catch (Exception e) {
      MYLOG.error(e);
    }
  }

  public static void closeRs(ResultSet rs) {
    try {
      if (rs != null) {
        rs.close();
      }
    } catch (Exception e) {
      MYLOG.error(e);
    }
  }

  public static void rollbackConn(Connection conn) {
    try {
      if (conn != null) {
        conn.rollback();
      }
    } catch (Exception e) {
      MYLOG.error(e);
    }
  }

  public static void main(String[] args) {
  }
}
