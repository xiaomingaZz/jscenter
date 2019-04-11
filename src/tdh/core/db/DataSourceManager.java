package tdh.core.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;

import tdh.util.DBUtils;
import tdh.util.JSUtils;

/**
 * 用于管理框架的数据库连接。
 * 
 */
public class DataSourceManager {

  private static final DataSourceManager INSTANCE = new DataSourceManager();

  private static Map<String, DataSource> datasourceMap = new HashMap<String, DataSource>();

  private DataSourceManager() {

  }

  public static DataSourceManager getInstnace() {
    return INSTANCE;
  }

  public void Starup() {
    List<DbConfig> lst = getDbList();
    for (DbConfig dbCfg : lst) {
      if ("1".equals(dbCfg.getSfljc()))
        buildDataSource(dbCfg);
    }

  }

  public DbConfig getDbCfg(String yydm, String jdbcName) {
    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;
    DbConfig dbCfg = null;
    try {
      conn = DBUtils.getDpzsConn();
      st = conn.createStatement();
      String sql = "";

      sql = "select YYDM, JDBCNAME, URL, USR, PWD, SFJY, SFLJC from DPZS_DB where isnull(SFJY, '0') <> '1' ";
      sql += " and YYDM='" + yydm + "' and JDBCNAME='" + jdbcName + "'";
      rs = st.executeQuery(sql);
      if (rs.next()) {
        dbCfg = new DbConfig();
        dbCfg.setYydm(JSUtils.trim(rs.getString("YYDM")));
        dbCfg.setJdbcname(JSUtils.trim(rs.getString("JDBCNAME")));
        dbCfg.setDburl(JSUtils.trim(rs.getString("URL")));
        dbCfg.setDbuser(JSUtils.trim(rs.getString("USR")));
        dbCfg.setDbpwd(JSUtils.trim(rs.getString("PWD")));
        dbCfg.setSfjy(JSUtils.trim(rs.getString("SFJY")));
        dbCfg.setSfljc(JSUtils.trim(rs.getString("SFLJC")));
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DBUtils.close(conn, st, rs);
    }
    return dbCfg;
  }

  public List<DbConfig> getDbList() {
    Connection conn = null;
    Statement st = null;
    ResultSet rs = null;
    List<DbConfig> lst = new ArrayList<DbConfig>();
    try {
      conn = DBUtils.getDpzsConn();
      st = conn.createStatement();

      String sql = "select YYDM, JDBCNAME, URL, USR, PWD, SFJY, SFLJC from DPZS_DB where isnull(SFJY, '0') <> '1' ";
      
      rs = st.executeQuery(sql);
      while (rs.next()) {
        DbConfig dbCfg = new DbConfig();
        dbCfg.setYydm(JSUtils.trim(rs.getString("YYDM")));
        dbCfg.setJdbcname(JSUtils.trim(rs.getString("JDBCNAME")));
        dbCfg.setDburl(JSUtils.trim(rs.getString("URL")));
        dbCfg.setDbuser(JSUtils.trim(rs.getString("USR")));
        dbCfg.setDbpwd(JSUtils.trim(rs.getString("PWD")));
        dbCfg.setSfjy(JSUtils.trim(rs.getString("SFJY")));
        dbCfg.setSfljc(JSUtils.trim(rs.getString("SFLJC")));

        lst.add(dbCfg);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      DBUtils.close(conn, st, rs);
    }
    return lst;
  }

  /**
   * 关闭数据库连接池
   */
  public void Shutdown() {
    System.out.println("正在关闭数据库连接池");
    Set<Map.Entry<String, DataSource>> ents = datasourceMap.entrySet();
    for (Map.Entry<String, DataSource> ent : ents) {
      try {
        ((BasicDataSource) ent.getValue()).close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
    datasourceMap.clear();
  }

  private void buildDataSource(DbConfig dbCfg) {
    System.out.println("开始创建框架库连接池：" + dbCfg.getDburl());
    BasicDataSource bds = new BasicDataSource();
    bds.setUrl(dbCfg.getDburl());
    bds.setDriverClassName("com.sybase.jdbc3.jdbc.SybDriver");
    bds.setUsername(dbCfg.getDbuser());
    bds.setPassword(dbCfg.getDbpwd());
    bds.setMaxActive(5);
    bds.setMaxIdle(2);
    bds.setMaxWait(2000);
    bds.setDefaultAutoCommit(false);
    datasourceMap.put(dbCfg.getYydm() + "." + dbCfg.getJdbcname(), bds);
  }

  private Connection getConn(String url, String username, String password) {
    Connection conn = null;
    try {
      if (url.toLowerCase().indexOf("sybase") > 0) {
        Class.forName("com.sybase.jdbc3.jdbc.SybDriver");
        conn = DriverManager.getConnection(url, username, password);
      }
      // microsoft:sqlserver
      if (url.toLowerCase().indexOf("microsoft:sqlserver") > 0) {
        Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
        conn = DriverManager.getConnection(url, username, password);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return conn;
  }

  /**
   * 获取指定的框架的数据库连接.
   * 
   * @return
   */
  public Connection getConnection(DbConfig dbCfg) {
    try {
      if ("1".equals(dbCfg.getSfljc())) {
        return datasourceMap.get(dbCfg.getYydm() + "." + dbCfg.getJdbcname()).getConnection();
      } else {
        return getConn(dbCfg.getDburl(), dbCfg.getDbuser(), dbCfg.getDbpwd());
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return null;
  }

  /**
   * 通过id来获取一个数据库的连接信息。
   * 
   * @return
   */
  public Connection getConnection(String yydm, String jdbcName) {
    DbConfig cfg = getDbCfg(yydm, jdbcName);
    if (cfg != null)
      return getConnection(cfg);
    return null;
  }

}
