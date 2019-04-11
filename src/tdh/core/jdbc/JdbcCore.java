package tdh.core.jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import tdh.core.jdbc.page.PageBean;
import tdh.core.jdbc.page.ResultBean;
import tdh.util.DBUtils;

@SuppressWarnings("unchecked")
public class JdbcCore {

  public static void setPst(PreparedStatement pst, Object[] params) throws SQLException {
    // ParameterMetaData pmd = null;
    //    
    // pmd = pst.getParameterMetaData();
    // int stmtCount = pmd.getParameterCount();
    // int paramsCount = params == null ? 0 : params.length;
    // if (stmtCount != paramsCount) {
    // throw new SQLException("Wrong number of parameters: expected " +
    // stmtCount + ", was given " + paramsCount);
    // }
    for (int i = 0; i < params.length; i++) {
      if (params[i] != null) {
        pst.setObject(i + 1, params[i]);
      } else {
        int sqlType = Types.VARCHAR;
        // try {
        // sqlType = pmd.getParameterType(i + 1);
        // } catch (SQLException e) {
        // }
        pst.setNull(i + 1, sqlType);
      }
    }
  }

  public static List<Map<String, Object>> queryForList(String sql, Object[] params, Connection conn) throws SQLException {
    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    Map<String, Object> map = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    ResultSetMetaData rsmd = null;

    try {
      pst = conn.prepareStatement(sql);

      setPst(pst, params);

      rs = pst.executeQuery();
      rsmd = rs.getMetaData();
      int cnt = rsmd.getColumnCount();
      String[] columnNames = new String[cnt];
      for (int i = 0; i < cnt; i++) {
        columnNames[i] = rsmd.getColumnLabel(i + 1);
      }
      while (rs.next()) {
        map = new HashMap<String, Object>();
        for (int i = 0; i < cnt; i++) {
          map.put(columnNames[i], rs.getObject(i + 1));
        }
        list.add(map);
      }
    } catch (SQLException e) {
      e.printStackTrace();
      throw e;
    } finally {
      DBUtils.close(null, pst, rs);
    }
    return list;
  }

  /**
   * 根据sql查询，返回list<map>
   * 
   * @param sql sql
   * @return list<map>
   * @throws SQLException
   * @throws IOException 
   */
  public static List<Map<String, Object>> queryForList(String sql, Connection conn) throws SQLException, IOException {
    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    Map<String, Object> map = null;
    Statement st = null;
    ResultSet rs = null;
    ResultSetMetaData rsmd = null;
    try {
      st = conn.createStatement();
      rs = st.executeQuery(sql);
      rsmd = rs.getMetaData();
      int cnt = rsmd.getColumnCount();
      String[] columnNames = new String[cnt];
      for (int i = 0; i < cnt; i++) {
        columnNames[i] = rsmd.getColumnLabel(i + 1);
      }
      while (rs.next()) {
        map = new HashMap<String, Object>();
        for (int i = 0; i < cnt; i++) {
          Object re = rs.getObject(i + 1);
          if (re != null) {
            map.put(columnNames[i], rs.getObject(i + 1));
          } else {
            map.put(columnNames[i], rs.getObject(i + 1));
          }

          // if (columnNames[i].equals("WKLSQK")) {
          // Clob clob = (Clob) rs.getObject(i + 1);
          // map.put(columnNames[i], clobToString(clob));
          // } else {
          // map.put(columnNames[i], rs.getObject(i + 1));
          // }

        }
        list.add(map);
      }
    } catch (SQLException e) {
      e.printStackTrace();
      throw e;
    } finally {
      DBUtils.close(null, st, rs);
    }
    return list;
  }
  /**
   * 根据sql查询，返回list<map>
   * 
   * @param sql sql
   * @param page 分页参数
   * @return list<map>
   * @throws SQLException
   */
  public static ResultBean queryForListPage(PageBean page, Connection conn) throws SQLException {
    List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
    Map<String, Object> map = null;
    Statement st = null;
    ResultSet rs = null;
    ResultSetMetaData rsmd = null;

    Statement st1 = null;
    ResultSet rs1 = null;

    int limit = page.getLimit();
    int start = page.getStartRow();
    int total = 0;
    String countSql = page.getCountSql();
    String sql = page.getSql();

    ResultBean result = new ResultBean();
    try {
      st1 = conn.createStatement();
      rs1 = st1.executeQuery(countSql);
      if (rs1.next()) {
        total = rs1.getInt(1);
      }
      result.setTotalRows(total);
      if (total <= start) {
        result.setResult(list);
        return result;
      }

      st = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
      rs = st.executeQuery(sql);
      rsmd = rs.getMetaData();
      int cnt = rsmd.getColumnCount();
      String[] columnNames = new String[cnt];
      for (int i = 0; i < cnt; i++) {
        columnNames[i] = rsmd.getColumnLabel(i + 1);
      }

      // 定位到某一页的第一条记录
      rs.absolute(start + 1);
      do {
        map = new HashMap<String, Object>();
        for (int i = 0; i < cnt; i++) {
          map.put(columnNames[i], rs.getObject(i + 1));
        }
        list.add(map);
      } while ((rs.getRow() < start + limit) && rs.next());

    } catch (SQLException e) {
      e.printStackTrace();
      throw e;
    } finally {
      DBUtils.close(null, st, rs);
      DBUtils.close(null, st1, rs1);
    }
    result.setResult(list);
    return result;
  }
  /**
   * 根据sql查询，返回第一条记录map
   * 
   * @param sql sql
   * @return map
   * @throws SQLException
   * @author 仇国庆
   * @throws IOException 
   * @date 2013-8-13
   */
  public static Map<String, Object> queryForMap(String sql, Connection conn) throws SQLException, IOException {
    List<Map<String, Object>> list = queryForList(sql, conn);
    if (list != null && list.size() > 0) {
      return list.get(0);
    } else {
      return null;
    }
  }

  /**
   * 根据sql查询，返回第一条记录map
   * 
   * @param sql sql
   * @param params 参数数组
   * @return map
   * @throws SQLException
   * @author 仇国庆
   * @date 2013-8-13
   */
  public static Map<String, Object> queryForMap(String sql, Object[] params, Connection conn) throws SQLException {
    List<Map<String, Object>> list = queryForList(sql, params, conn);
    if (list != null && list.size() > 0) {
      return list.get(0);
    } else {
      return null;
    }
  }

  /**
   * 更新
   * 
   * @param sql
   * @return 更新记录成功数
   * @throws SQLException
   */
  public static int executeUpdate(String sql, Connection conn) throws SQLException {
    Statement st = null;
    int rowCnt = 0;
    try {
      st = conn.createStatement();
      rowCnt = st.executeUpdate(sql);
    } catch (SQLException e) {
      e.printStackTrace();
      throw e;
    } finally {
      DBUtils.close(null, st, null);
    }
    return rowCnt;
  }

  /**
   * 更新
   * 
   * @param sql
   * @param arrayTypes 参数类型数组(类型需严格控制)
   * @param arrayParams 参数数组(参数值类型需严格对照参数类型数组)
   * @return 更新记录成功数
   * @throws SQLException
   */
  public static int executeUpdate(String sql, Object[] params, Connection conn) throws SQLException {
    PreparedStatement pst = null;
    int rowCnt = 0;
    try {
      pst = conn.prepareStatement(sql);

      setPst(pst, params);

      rowCnt = pst.executeUpdate();
    } catch (SQLException e) {
      e.printStackTrace();
      throw e;
    } finally {
      DBUtils.close(null, pst, null);
    }
    return rowCnt;
  }



  /**
   * 根据sql查询top，返回list, 注意该方法使用事务<map>
   * 
   * @param sql sql
   * @return list<map>
   * @throws SQLException
   * @throws IOException 
   */
  public static List<Map<String, Object>> queryForTop(String sql, int top, Connection conn) throws SQLException, IOException {
    JdbcCore.executeUpdate("set rowcount " + top, conn);
    List<Map<String, Object>> list = JdbcCore.queryForList(sql, conn);
    JdbcCore.executeUpdate("set rowcount 0", conn);
    return list;
  }

  /**
   * 根据sql查询top，返回list, 注意该方法使用事务<map>
   * 
   * @param sql sql
   * @param arrayTypes 参数类型数组(类型需严格控制)
   * @param arrayParams 参数数组(参数值类型需严格对照参数类型数组)
   * @return list<map>
   * @throws SQLException
   */
  public static List<Map<String, Object>> queryForTop(String sql, Object[] params, int top, Connection conn) throws SQLException {
    JdbcCore.executeUpdate("set rowcount " + top, conn);
    List<Map<String, Object>> list = JdbcCore.queryForList(sql, params, conn);
    JdbcCore.executeUpdate("set rowcount 0", conn);
    return list;
  }

  /**
   * 
   * @author 张国宁 2015-3-6 下午03:22:40
   * @param sql
   * @param conn
   * @return
   * @throws SQLException
   * @throws IOException
   *           String
   */
  public static int queryForInt(String sql, Connection conn) throws SQLException, IOException {
    List<Map<String, Object>> list = queryForList(sql, conn);
    if (list != null && list.size() > 0) {
      Map<String, Object> map = list.get(0);
      Integer cnt = (Integer) map.get("CNT");
      if (cnt == null)
        cnt = 0;
      return cnt;
    } else {
      return 0;
    }
  }
  
  public static void main(String[] args) {
    // 更新eg
    // String ahdm = "115100000000060";
    // String sql = "update EAJ set AH='AHAH' where AHDM = ?";
    // Object[] arrayParams = {ahdm};
    // int[] arrayTypes = {java.sql.Types.VARCHAR};
    // JdbcTemplete.executeUpdate(sql, arrayTypes, arrayParams);
    // 原操作方式pst.setObject(j + 1, arrayParams[j], arrayTypes[j]);

    // 分页 eg
    // String sql = "select * from EAJ where LSAH = ?";
    // Object[] arrayParams = {"20100000007"};
    // int[] arrayTypes = {java.sql.Types.VARCHAR};
    // System.out.println("开始");
    // List<Map<String, Object>> list1 = JdbcCore.executeQuery(sql, arrayTypes,
    // arrayParams);
    // System.out.println("size" + list1.size());
    // for (int i = 0; i < list1.size(); i++) {
    // System.out.println("号" + (i+1) + ":" + list1.get(i).get("AHDM"));
    // }
    // System.out.println("结束");
    // PageBean page = JdbcCore.queryForListPage(sql, arrayTypes, arrayParams,
    // new PageBean(5,5));
    // List<Map<String, Object>> list = page.getList();
    // System.out.println("total:" + page.getTotal());
    // System.out.println("size:" + list.size());
    // for (int i = 0; i < list.size(); i++) {
    // System.out.println("号" + (i+1) + ":" + list.get(i).get("AHDM"));
    // }

  }
}